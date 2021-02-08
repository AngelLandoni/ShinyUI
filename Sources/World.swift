//  Copyright (c) 2021 Angel Landoni.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIEDi
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

typealias ParentElementID = ElementID
typealias ChildElementID = ElementID

typealias ElementBuilder = () -> Element

// TODO: Move to a real ECS.
final class World {

    // MARK: Elements

    var rootElement: ElementID?
    var rootDisplayElement: DisplayElement?

    /// Contains all the existing elements in the tree.
    private(set) var elements: [ElementID: Element] = [:]
    /// Contains links between the parent and its children.
    private(set) var parentToChildren: [ParentElementID: OrderedSet<ChildElementID>] = [:]
    /// Contains links between the child (as the key) and its parent.
    private(set) var childToParent: [ChildElementID: ParentElementID] = [:]
    /// Contains a link between the element and the view.
    private(set) var viewForElement: [ElementID: AnyView] = [:]
    /// Contains the displays currently rendered on screen.
    private(set) var displays: [ElementID: DisplayElement] = [:]
    /// Contains the `Element` size and position.
    private(set) var frames: [ElementID: ElementFrame] = [:]
    /// Contains a list of `Element` to be recalculated.
    private(set) var currentInvalidElements: Set<ElementID> = []

    // MARK: Global

    private(set) var screenSize: Size<Float> = .zero

    // MARK: Private

    private let maintainLock: Lock = Lock()

    // MARK: Lifecycle

    init() {}
}

// MARK: - Element registration and linking

extension World {
    /// Registers a new element in the `World`.
    ///
    /// - Parameters:
    ///     - element: The `Element` to be registered.
    ///     - representedBy: The actual `View` that represents that `Element`.
    ///
    /// - Returns: The same element provided by parameter.
    @discardableResult
    func register(_ element: Element,
                  representedBy view: View) -> Element {
        elements[element.elementID] = element
        precondition(!(view is AnyView), ErrorMessages.anyViewNotAllowed)
        viewForElement[element.elementID] = view.asAny
        updateViewStateOwner(view, newOwner: element, world: self)
        return element
    }
    
    @discardableResult
    func link(child: Element, toParent element: Element) -> Element {
        // Register the child as a child of the parent element.
        parentToChildren[element.elementID] = [child.elementID]
        // Register the parent element as the parent of the child.
        childToParent[child.elementID] = element.elementID
        return child
    }

    @discardableResult
    func link(children: [Element], toParent parent: Element) -> [Element] {
        // To map from array to set.
        var dataSet: OrderedSet<ElementID> = OrderedSet<ElementID>()

        // Map to set.
        for child in children {
            // Send the element ID.
            dataSet.append(child.elementID)

            // Register the parent as parent of each child.
            self.childToParent[child.elementID] = parent.elementID
        }

        // Register the child as a child of element.
        self.parentToChildren[parent.elementID] = dataSet

        return children
    }
}

// MARK: - Query

extension World {
    func element(for elementID: ElementID) -> Element? {
        elements[elementID]
    }

    func children(of parent: ElementID) -> OrderedSet<ElementID>? {
        parentToChildren[parent]
    }

    func children(of parent: Element) -> OrderedSet<ElementID>? {
        parentToChildren[parent.elementID]
    }

    func frame(of elementID: ElementID) -> ElementFrame? {
        frames[elementID]
    }
}

// MARK: - Display element registration and linking

extension World {
    /// Registers a new display in the `World` virtual tree.
    ///
    /// - parameters:
    ///     - displayElement: The `DisplayElement` to be registered in the `World`.
    ///     - id: The ID(`DisplayElementID`) associated with the display.
    func registerDisplay(_ displayElement: DisplayElement,
                         _ id: ElementID) {
        // Register the display.
        displays[id] = displayElement
    }

    /// Forces the execution of the `didRender` method inside the view associated with the `Element`.
    ///
    /// - Parameter elementID: The `ElementID`  used to get the associated `View`.
    func displayAsBeenRendered(_ elementID: ElementID) {
        viewForElement[elementID]?.didRender()
    }
}

// MARK: - Layout

extension World {
    func updateScreenSize(_ screenSize: Size<Float>) {
        rootDisplayElement?.updateFrame(.fromOrigin(screenSize))
        self.screenSize = screenSize
    }

    func layout() {
        // Check if the world has an initial element.
        guard let rootElement = rootElement else {
            fatalError("The root element does not exists and it is needed to layout the ui")
        }
        layout(rootElement)
    }

    func layout(_ elementID: ElementID) {
        guard let layoutElement = elements[elementID] as? Layout else {
            return
        }
        layoutElement.layout(screenSize, self)
    }

    func syncLayoutAndDisplay() {
        for (elementID, frame) in frames {
            guard let display = displays[elementID] else {
                continue
            }
            display.updateFrame(frame)
        }
    }

    /// Updates or creates the frame of the given element.
    ///
    /// - Parameters:
    ///     - elementID: The id of the 'Element' to be updated.
    func updateElementFrame(_ elementID: ElementID, _ frame: ElementFrame) {
        frames[elementID] = frame
    }
}

// MARK: Invalidation

extension World {
    /// Marks an element as invalid.
    ///
    /// - Parameter elementID: The `Element`'s id used to mark the element as invalid.
    func markAsInvalid(_ elementID: ElementID) {
        guard !currentInvalidElements.contains(elementID) else { return }

        // If the element does not exist just avoid invalidation, this can
        // happen when the father element contains a state and the child
        // a Binder derived from that State and both bodies are recreated.
        // As order is not guaranteed ,yet, there is a possibility that the
        // father recreates the body and remove the old element, when the
        // binder tries to invalidate it it does not exits any more.
        guard element(for: elementID) != nil else { return }

        // This should be performed safely before the frame is done, or
        // maybe we can skip some frames?, TBD.
        currentInvalidElements.insert(elementID)
    }

    /// Mark the root element as invalid.
    ///
    /// - TODO: Optimization needed.
    func markRootAsInvalid() {
        // The main root will be invalidated it means all the elements are
        // not valid any more.
        currentInvalidElements.removeAll()

        guard let rootElement = rootElement else {
            fatalError("Root element does not exist")
        }

        // Inser the root element in the invalidation list.
        currentInvalidElements.insert(rootElement)
    }
}

// MARK: maintain

extension World {
    /// Maintain the `World`.
    ///
    /// It is responsible for keeping the `Element` tree updated with the changes of the `State`.
    /// The old elements that were replaced with the new ones will be removed and removed from the trees
    /// (for now only) as well as the `DisplayElement`.
    ///
    /// This method must be called periodically to display the correct state on screen.
    ///
    /// - Note: Animations are not contemplated for now.
    func maintain() {
        recreateTreeAfterInvalidationOccurs()
    }

    /// Recreate all the trees just for the invalid elements.
    ///
    /// - TODO: Fix this, SUUUUUPPPER SLOWWWWWW.
    /// - TODO: Diffing.
    /// - TODO: Order by descendants if some of them are in the same branch
    ///         rebuild just ignore it, it is not needed, currently it is doing extra work.
    func recreateTreeAfterInvalidationOccurs() {
        // If there are not invalid element skip the current frame.
        if currentInvalidElements.isEmpty { return }

        // Rebuild the tree and replace needed.
        for element in currentInvalidElements {
            // We have to fix this from a higher level, avoids the already
            // removed child generation, something like (is element in branch).
            // Ugly hack to make it works (Implement tree depth).
            guard elements[element] != nil else { continue }

            guard let view: AnyView = viewForElement[element] else {
                fatalError("The element does not have an associated view")
            }

            // Clean the tree no more invalid elements.
            removeElementTree(element)

            // `builder` already injects the elements inside the tree so
            // we need a flag to check after execution.
            let clearElementTree: Bool = elements.isEmpty
            // Create the new tree. It already generates the tree and sets the
            // hooks.
            // TODO: Remove old builders.
            let newElement: Element = view.build(self)

            // Replace as child.
            replaceElementAsChild(element, newElement.elementID)

            emitMountLifecycleEvent(for: newElement.elementID)

            // If there are not elements in the world means it deleted the root
            // element and it must be replace.
            if clearElementTree {
                rootElement = newElement.elementID

                guard let rootDisplayElement = rootDisplayElement else {
                    fatalError("World does not have a root host to render on")
                }

                buildDisplayElementTree(newElement,
                                        self,
                                        rootDisplayElement)
            } else {
                // TODO: find a way to merge the trees and reuse the displays.

                // Find the parent display to display the new content inside it.
                let host: DisplayElement
                    = findFirstParentElementWithDisplay(newElement.elementID)

                buildDisplayElementTree(newElement, self, host)
            }

            // Relayout everything.
            // TODO: Move this to background, find a better way to layout
            // the branch is recalculated but the parent should be aware if that
            //
            let elementID = findFirstLayoutBoundary(newElement.elementID)
            layout(elementID)

            #if DEBUG
            // printElementTree()
            #endif
        }

        // Remove all from the list.
        currentInvalidElements.removeAll()

        // TODO: Too heavy just perform update over updated elements.
        syncLayoutAndDisplay()
    }
}

// MARK: - Utils

extension World {
    /// Removes an `Element` form the tree along with children.
    ///
    /// - Parameter elementID: The `Element`'s id to identify the element and delete it.
    func removeElementTree(_ elementID: ElementID) {
        // Removes the element from the list of elements.
        removeElement(for: elementID)
        // Remove the frame associated with the element.
        removeFrame(for: elementID)
        // Remove the display associated with the element.
        removeDisplay(for: elementID)
        // Find the children and delete them too.
        removeChildren(for: elementID)

        // Emit unmount signal before remove the view from the tree.
        emitUnmountLifecycleEvent(for: elementID)
        // Remove the view associated with the element.
        removeView(for: elementID)
    }

    func removeElement(for elementID: ElementID) {
        elements.removeValue(forKey: elementID)
    }

    func removeFrame(for elementID: ElementID) {
        frames.removeValue(forKey: elementID)
    }

    func removeDisplay(for elementID: ElementID) {
        // Remove display only if the element has one attached.
        guard let displayElement = displays[elementID] else {
            print("The element \(elementID) does not have visual representation")
            return
        }
        // Force the display to be removed.
        displayElement.remove()
        // Remove the display from the list.
        displays.removeValue(forKey: elementID)
    }

    func removeView(for elementID: ElementID) {
        viewForElement.removeValue(forKey: elementID)
    }

    func removeChildren(for elementID: ElementID) {
        guard let children = parentToChildren[elementID] else { return }
        for child in children {
            // Remove child element from any link.
            self.childToParent.removeValue(forKey: child)
            removeElementTree(child)
        }
        // Delete the element as parent.
        parentToChildren.removeValue(forKey: elementID)
    }

    func replaceElementAsChild(_ elementID: ElementID,
                               _ newElementID: ElementID) {
        // Find the parent of the old element.
        guard let parentID = childToParent[elementID] else { return }
        // Remove old link.
        childToParent.removeValue(forKey: elementID)
        // Set the parentID as the parent of the new element.
        childToParent[newElementID] = parentID
        // Remove it from the children.

        // Insert in the position of the old element, O(n).
        parentToChildren[parentID]?.replace(element: elementID,
                                            with: newElementID)
    }

    /// Walks the `Element` tree from bottom to top and try to find any parent `DisplayElement`
    /// associated with the `ElementID` provided.
    ///
    /// If it can not find any `DisplayElement` it will return the root `DisplayElement`.
    ///
    /// - Note: This method is useful when the tree must be rebuild and root Element does not
    ///         contain a `DisplayElement` attached to it.
    ///
    /// TBD: Maybe if the element does not have visual representation (`DisplayElement`) it can
    /// insert the parent `DisplayElementID` as its `DisplayElement` so we can avoid walk
    /// the tree O(N) -> O(1).
    func findFirstParentElementWithDisplay(
        _ elementID: ElementID) -> DisplayElement {
        var currentElementID: ElementID = elementID
        while true {
            // Check if there is an associated display.
            if let display = displays[currentElementID] {
                return display
            }
            // Check if the element has parent and if possible move to it.
            if let parentElementID = childToParent[currentElementID] {
                currentElementID = parentElementID
                continue
            }
            // If there are not parent it means it reached the top, and it
            // must return the root display.
            guard let rootDisplayElement = rootDisplayElement else {
                fatalError("World does not contain a root Display element")
            }

            return rootDisplayElement
        }
    }

    /// Walks the tree looking for the boundary layout parent or the root element.
    ///
    /// - Parameter elementID: The anchor element used to find the boundary parent.
    func findFirstLayoutBoundary(_ elementID: ElementID) -> ElementID {
        var currentElementID: ElementID = elementID
        while true {
            // Check if the current element is boundary.
            if let elementLayout = elements[currentElementID] as? Layout {
                // If the layout should propagate to the parent just sets the
                // current element id to the parent.
                if elementLayout.shouldPropagateToParent {
                    if let parentElementID = childToParent[currentElementID] {
                        currentElementID = parentElementID
                        continue
                    }
                    // The child does not have parent so it must return itself.
                    else {
                        return currentElementID
                    }
                }
            }
            // If the current element does not have layout try to reach the
            // parent.
            else {
                if let parentElementID = childToParent[currentElementID] {
                    currentElementID = parentElementID
                    continue
                }
                // The child does not have parent so it must return itself.
                else {
                    return currentElementID
                }
            }
        }
        return currentElementID
    }
}

// MARK: - Lifecycle Helpers

fileprivate extension World {
    /// Calls the `didUnmount` method for the associated `View`.
    ///
    /// - Parameter for: The `Element` used to find the associated `View`.
    func emitUnmountLifecycleEvent(for elementID: ElementID) {
        let view: AnyView? = viewForElement[elementID]
        view?.didUnmount()
    }

    /// Cals the `didMount` method for the associated `View`.
    ///
    /// - Parameter for: The `Element` used to find the associated `View`.
    func emitMountLifecycleEvent(for elementID: ElementID) {
        let view: AnyView? = viewForElement[elementID]
        view?.didMount()
    }
}

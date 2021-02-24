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

final class World: Storable {
    fileprivate var _rootElement: ElementID?
    fileprivate var rootDisplayElement: DisplayElement?
    fileprivate var screenSize: Size<Float> = .zero

    /// Contains all the existing elements in the tree.
    fileprivate var elements: [ElementID: Element] = [:]
    /// Contains links between the parent and its children.
    fileprivate var parentToChildren: [ParentElementID: OrderedSet<ChildElementID>] = [:]
    /// Contains links between the child (as the key) and its parent.
    fileprivate var childToParent: [ChildElementID: ParentElementID] = [:]
    /// Contains a link between the element and the view.
    fileprivate var viewForElement: [ElementID: AnyView] = [:]
    /// Contains the displays currently rendered on screen.
    fileprivate var displays: [ElementID: DisplayElement] = [:]
    /// Contains the `Element` size and position.
    fileprivate var frames: [ElementID: ElementFrame] = [:]
    /// Contains a list of `Element` to be recalculated.
    fileprivate var currentInvalidElements: Set<ElementID> = []
    
    fileprivate var enviromentStack: [ObjectIdentifier: EnviromentProperty] = [:]

    init() {}
}

extension World {
    func updateScreenSize(_ screenSize: Size<Float>) {
        rootDisplayElement?.updateFrame(.fromOrigin(screenSize))
        self.screenSize = screenSize
    }

    func syncLayoutAndDisplay() {
        for (elementID, frame) in frames {
            guard let display = displays[elementID] else {
                continue
            }
            display.updateFrame(frame)
        }
    }
}

extension World {
    func doubleLink(child: ElementID, and parent: ElementID) {
        link(child: child, to: parent)
        link(parent: parent, to: child)
    }
    
    func link(child: ElementID, to parent: ElementID) {
        parentToChildren[parent] = [child]
    }
    
    func link(addingChild child: ElementID, to parent: ElementID) {
        parentToChildren[parent]?.append(child)
    }
    
    func link(children: OrderedSet<ElementID>, to parent: ElementID) {
        parentToChildren[parent] = children
    }
    
    func link(parent: ElementID, to child: ElementID) {
        childToParent[child] = parent
    }
    
    func unlink(child: ElementID) {
        childToParent.removeValue(forKey: child)
    }
}

extension World {
    func element(for elementID: ElementID) -> Element? {
        elements[elementID]
    }
    
    func frame(of elementID: ElementID) -> ElementFrame? {
        frames[elementID]
    }
    
    var allFrames: [ElementID: ElementFrame] {
        self.frames
    }
    
    func view(for element: ElementID) -> AnyView? {
        viewForElement[element]
    }
    
    func display(for element: ElementID) -> DisplayElement? {
        displays[element]
    }
}
    
extension World {
    func children(of parent: ElementID) -> OrderedSet<ElementID>? {
        parentToChildren[parent]
    }

    func children(of parent: Element) -> OrderedSet<ElementID>? {
        parentToChildren[parent.elementID]
    }

    func parent(of element: ElementID) -> ElementID? {
        childToParent[element]
    }
}
    
extension World {
    func replaceChild(_ child: ElementID,
                      with newChild: ElementID,
                      for parent: ElementID) {
        parentToChildren[parent]?.replace(element: child, with: newChild)
    }
}
    
extension World {
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
            removeElementTree(element: child, in: self)
        }
        // Delete the element as parent.
        parentToChildren.removeValue(forKey: elementID)
    }
}

extension World {
    /// Registers a new display in the `World` virtual tree.
    ///
    /// - parameters:
    ///     - displayElement: The `DisplayElement` to be registered in the `World`.
    ///     - id: The ID(`DisplayElementID`) associated with the display.
    func registerDisplay(element: DisplayElement, with id: ElementID) {
        displays[id] = element
    }
    
    func register(elementId: ElementID, to element: Element) {
        elements[elementId] = element
    }
    
    func register<V: View>(elementId: ElementID, to view: V) {
        viewForElement[elementId] = view.asAny
    }
}

extension World {
    /// Forces the execution of the `didRender` method inside the view associated with the `Element`.
    ///
    /// - Parameter elementID: The `ElementID`  used to get the associated `View`.
    func displayHasBeenRendered(_ elementID: ElementID) {
        viewForElement[elementID]?.didRender()
    }
}

extension World {
    func updateRoot(with element: ElementID) {
        _rootElement = element
    }
    
    func updateRootDisplay(element: DisplayElement) {
        rootDisplayElement = element
    }
    
    /// Updates or creates the frame of the given element.
    ///
    /// - Parameters:
    ///     - elementID: The id of the 'Element' to be updated.
    func updateFrame(of elementID: ElementID, with frame: ElementFrame) {
        frames[elementID] = frame
    }
}
    
extension World {
    func clearInvalidElements () {
        currentInvalidElements.removeAll()
    }
}

extension World {
    /// Marks an element as invalid.
    ///
    /// - Parameter elementID: The `Element`'s id used to mark the element as invalid.
    func markAsInvalid(_ elementID: ElementID) {
        guard !currentInvalidElements.contains(elementID) else { return }

        // If the element does not exist just avoid invalidation, this can
        // happen when the father element contains a state and the child
        // a Binder derived from that State and both bodies are recreated.
        // As order is not guaranteed yet, there is a possibility that the
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

        guard let rootElement = _rootElement else {
            fatalError("Root element does not exist")
        }

        // Inser the root element in the invalidation list.
        currentInvalidElements.insert(rootElement)
    }
    
    var invalidElements: Set<ElementID> {
        currentInvalidElements
    }
    
    var areThereInvalidElements: Bool { !currentInvalidElements.isEmpty }
}

extension World {
    var rootElement: Element? {
        guard let root = _rootElement else { return nil }
        return element(for: root)
    }
    var constraint: Size<Float> { screenSize }
    var rootDisplay: DisplayElement? { rootDisplayElement }
    var areThereElements: Bool { !elements.isEmpty }
}

/// TODO: The way used to store the enviroment properties is not suitable in multithread enviroments.
/// If we want to build / generate the tree in background it will have unexpected behaviors due the current
/// approach.
extension World {
    /// Adds an `EnviromentProperty` to the `World`.
    ///
    /// This method updates the new property with the content of an already created property if the
    /// new property does not contain any value, if it contains the stored already created property
    /// will be updated.
    ///
    /// - Parameter property: The `EnviromentProperty` to be added or updated.
    /// - Returns: A boolean indicating if the property was added or updated.
    func addEnviroment(property: EnviromentProperty) -> Bool {
        if let storedProperty = enviromentProperty(for: property.identifier) {
            guard let propertyContent = property.content else {
                property.update(with: storedProperty.content)
                return false
            }
            storedProperty.update(with: propertyContent)
            return false
        }
        enviromentStack[property.identifier] = property
        return true
    }
    
    /// Removes an `EnviromentProperty` from the `World`.
    ///
    /// - Parameter with: The `EnviromentProperty` to be removed.
    func removeEnviroment(property: EnviromentProperty) {
        enviromentStack.removeValue(forKey: property.identifier)
    }
    
    /// Returns the `EnviromentProperty` associated with the provided `ObjectIdentifier`.
    ///
    /// - Parameter for: The `ObjectIdentifier` used to find the property.
    /// - Returns: If the element exists an `EnviromentProperty` if not a null.
    func enviromentProperty(for id: ObjectIdentifier) -> EnviromentProperty? {
        enviromentStack[id]
    }
    
    var enviromentProperties: [EnviromentProperty] {
        enviromentStack.map { $0.value }
    }
}

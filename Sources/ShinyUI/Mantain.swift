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

func mantain(world: World) {
    recreateTreeAfterInvaidationOccurs(in: world)
}

func recreateTreeAfterInvaidationOccurs<S: Storable>(in storable: S) {
    // If there are not invalid element skip the current frame.
    guard storable.areThereInvalidElements else { return }
    
    // Rebuild the tree and replace needed.
    for element in storable.invalidElements {
        // We have to fix this from a higher level, avoids the already
        // removed child generation, something like (is element in branch).
        // Ugly hack to make it works (Implement tree depth).
        guard storable.element(for: element) != nil else { continue }

        guard let view: AnyView = storable.view(for: element) else {
            fatalError("The element does not have an associated view")
        }
        
        // Clean the tree no more invalid elements.
        removeElementTree(element: element, in: storable)

        // `builder` already injects the elements inside the tree so
        // we need a flag to check after execution.
        let isElementTreeEmpty: Bool = !storable.areThereElements
        // Create the new tree. It already generates the tree and sets the
        // hooks.
        let newElement: Element = view.build(in: storable)

        // Replace as child.
        replaceElementAsChild(element,
                              newElement: newElement.elementID,
                              in: storable)
        
        emitMountLifecycleEvent(for: newElement.elementID, in: storable)

        recreateDisplayTree(isTreeEmpty: isElementTreeEmpty,
                            element: newElement.elementID,
                            storable: storable)
        
        layout(element: findFirstLayoutBoundary(from: newElement.elementID,
                                                in: storable),
               in: storable)
    }

    storable.clearInvalidElements()

    // TODO: Too heavy just perform update over updated elements.
    syncLayoutAndDisplay(of: storable)
}

func removeElementTree<S: Storable>(element: ElementID, in storable: S) {
    // Removes the element from the list of elements.
    storable.removeElement(for: element)
    // Remove the frame associated with the element.
    storable.removeFrame(for: element)
    // Remove the display associated with the element.
    storable.removeDisplay(for: element)
    // Find the children and delete them too.
    storable.removeChildren(for: element)
    
    emitUnmountLifecycleEvent(for: element, in: storable)
    
    storable.removeView(for: element)
}

func replaceElementAsChild<S: Storable>(_ element: ElementID,
                                        newElement: ElementID,
                                        in storable: S) {
    
    // Find the parent of the old element.
    guard let parent = storable.parent(of: element) else { return }
    // Remove old link.
    storable.unlink(child: element)
    // Set the parentID as the parent of the new element and the new element
    // as the child of the parent.
    storable.doubleLink(child: newElement, and: parent)
    // Insert in the position of the old element, O(n).
    storable.replaceChild(element, with: newElement, for: parent)
}

// TODO: find a way to merge the trees and reuse the displays.
func recreateDisplayTree<S: Storable>(isTreeEmpty: Bool,
                                      element: ElementID,
                                      storable: S) {
    // If there are not elements in the world means it deleted the root
    // element and it must be replace.
    if isTreeEmpty {
        storable.updateRoot(with: element)

        guard let rootDisplayElement = storable.rootDisplay else {
            fatalError(ErrorMessages.emptyRootDisplayElement)
        }
        
        guard let element = storable.element(for: element) else {
            fatalError(ErrorMessages.elementNotFound)
        }

        buildDisplayElementTree(element, storable, rootDisplayElement)
    } else {
        // Find the parent display to display the new content inside it.
        let host = findFirstParentWithDisplay(for: element, in: storable)
        buildDisplayElementTree(element, storable, host)
    }
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
func findFirstParentWithDisplay<S: Storable>(for element: ElementID,
                                             in storable: S) -> DisplayElement {
    var targetElement: ElementID = element
    while true {
        // Check if there is an associated display.
        if let display = storable.display(for: targetElement) { return display }
        // Check if the element has parent and if possible move to it.
        if let parent = storable.parent(of: targetElement) {
            targetElement = parent
            continue
        }
        // If the element does not have a parent it must Boxer to the root.
        guard let rootDisplayElement = storable.rootDisplay else {
            fatalError(ErrorMessages.emptyRootDisplayElement)
        }
        return rootDisplayElement
    }
}

func findFirstLayoutBoundary<S: Storable>(from element: ElementID,
                                          in storable: S) -> ElementID {
    var targetElement: ElementID = element
    while true {
        // If it is not possible to layout  the frame move to the parent.
        if let elayout = storable.element(for: targetElement) as? Layout {
            guard elayout.shouldPropagateToParent else { return targetElement }
        }
        // If the parent does not exist it must return the current
        // target as the propert element to measure.
        guard let parent = storable.parent(of: targetElement) else {
            return targetElement
        }
        // Set the parent as the new target.
        targetElement = parent
    }
    return targetElement
}

func syncLayoutAndDisplay<S: Storable>(of storable: S) {
    for (elementID, frame) in storable.allFrames {
        guard let display = storable.display(for: elementID) else {
            continue
        }
        display.updateFrame(frame)
    }
}

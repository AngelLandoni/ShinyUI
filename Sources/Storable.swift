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

protocol Storable: AnyObject {
    func doubleLink(child: ElementID, and parent: ElementID)
    func link(child: ElementID, to parent: ElementID)
    func link(children: OrderedSet<ElementID>, to parent: ElementID)
    func link(parent: ElementID, to child: ElementID)
    func unlink(child: ElementID)
    
    func element(for elementID: ElementID) -> Element?
    func frame(of elementID: ElementID) -> ElementFrame?
    var allFrames: [ElementID: ElementFrame] { get }
    func view(for element: ElementID) -> AnyView?
    func display(for element: ElementID) -> DisplayElement?
    
    func children(of parent: ElementID) -> OrderedSet<ElementID>?
    func children(of parent: Element) -> OrderedSet<ElementID>?
    func parent(of element: ElementID) -> ElementID?
    
    func replaceChild(_ child: ElementID,
                      with newChild: ElementID,
                      for parent: ElementID)
    
    func removeElement(for elementID: ElementID)
    func removeFrame(for elementID: ElementID)
    func removeDisplay(for elementID: ElementID)
    func removeView(for elementID: ElementID)
    func removeChildren(for elementID: ElementID)
    
    func registerDisplay(element: DisplayElement, with id: ElementID)
    func register(elementId: ElementID, to element: Element)
    func register<V: View>(elementId: ElementID, to view: V)
    
    func displayHasBeenRendered(_ elementID: ElementID)
    
    func updateRoot(with element: ElementID)
    func updateRootDisplay(element: DisplayElement)
    func updateFrame(of elementID: ElementID, with frame: ElementFrame)
    
    func clearInvalidElements()
    
    func markAsInvalid(_ elementID: ElementID)
    func markRootAsInvalid()
    // TODO: https://github.com/apple/swift/blob/main/docs/OwnershipManifesto.md
    var invalidElements: Set<ElementID> { get }
    var areThereInvalidElements: Bool { get }
    
    var rootElement: Element? { get }
    var rootDisplay: DisplayElement? { get }
    var constraint: Size<Float> { get }
    var areThereElements: Bool { get }
}



/// Registers a new element in the `World`.
///
/// - Parameters:
///     - element: The `Element` to be registered.
///     - representedBy: The actual `View` that represents that `Element`.
///
/// - Returns: The same element provided by parameter.
@discardableResult
func register<V: View, S: Storable>(element: Element,
                                    representedBy view: V,
                                    in storable: S) -> Element {
    storable.register(elementId: element.elementID, to: element)
    precondition(!(view is AnyView), ErrorMessages.anyViewNotAllowed)
    storable.register(elementId: element.elementID, to: view)
    updateViewStateOwner(view, newOwner: element, in: storable)
    return element
}

@discardableResult
func link<S: Storable>(child: Element,
                       to parent: Element,
                       in storable: S) -> Element {
    storable.link(child: child.elementID, to: parent.elementID)
    storable.link(parent: parent.elementID, to: child.elementID)
    return child
}

@discardableResult
func link<S: Storable>(children: [Element],
                       to parent: Element,
                       in storable: S) -> [Element] {
    var dataSet: OrderedSet<ElementID> = OrderedSet<ElementID>()
    
    for child in children {
        // Send the element ID.
        dataSet.append(child.elementID)
        storable.link(parent: parent.elementID, to: child.elementID)
    }
    
    storable.link(children: dataSet, to: parent.elementID)
    return children
}

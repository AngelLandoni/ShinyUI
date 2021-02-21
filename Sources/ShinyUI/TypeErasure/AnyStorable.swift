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

/// Hack to make generics works on the AnyView implementation and avoid
/// do an specific implementation for the existential case.
final class AnyStorable: Storable {
    private let storage: Storable

    init<S: Storable>(_ storable: S) {
        storage = storable
    }
    
    func doubleLink(child: ElementID, and parent: ElementID) {
        storage.doubleLink(child: child, and: parent)
    }
    
    func link(child: ElementID, to parent: ElementID) {
        storage.link(child: child, to: parent)
    }
    
    func link(addingChild child: ElementID, to parent: ElementID) {
        storage.link(addingChild: child, to: parent)
    }
    
    func link(children: OrderedSet<ElementID>, to parent: ElementID) {
        storage.link(children: children, to: parent)
    }
    
    func link(parent: ElementID, to child: ElementID) {
        storage.link(parent: parent, to: child)
    }
    
    func unlink(child: ElementID) {
        storage.unlink(child: child)
    }
    
    func element(for elementID: ElementID) -> Element? {
        storage.element(for: elementID)
    }
    
    func frame(of elementID: ElementID) -> ElementFrame? {
        storage.frame(of: elementID)
    }
    
    var allFrames: [ElementID : ElementFrame] {
        storage.allFrames
    }
    
    func view(for element: ElementID) -> AnyView? {
        storage.view(for: element)
    }
    
    func display(for element: ElementID) -> DisplayElement? {
        storage.display(for: element)
    }
    
    func children(of parent: ElementID) -> OrderedSet<ElementID>? {
        storage.children(of: parent)
    }
    
    func children(of parent: Element) -> OrderedSet<ElementID>? {
        storage.children(of: parent)
    }
    
    func parent(of element: ElementID) -> ElementID? {
        storage.parent(of: element)
    }
    
    func replaceChild(_ child: ElementID,
                      with newChild: ElementID,
                      for parent: ElementID) {
        storage.replaceChild(child, with: newChild, for: parent)
    }
    
    func removeElement(for elementID: ElementID) {
        storage.removeElement(for: elementID)
    }
    
    func removeFrame(for elementID: ElementID) {
        storage.removeFrame(for: elementID)
    }
    
    func removeDisplay(for elementID: ElementID) {
        storage.removeDisplay(for: elementID)
    }
    
    func removeView(for elementID: ElementID) {
        storage.removeView(for: elementID)
    }
    
    func removeChildren(for elementID: ElementID) {
        storage.removeChildren(for: elementID)
    }
    
    func registerDisplay(element: DisplayElement, with id: ElementID) {
        storage.registerDisplay(element: element, with: id)
    }
    func register(elementId: ElementID, to element: Element) {
        storage.register(elementId: elementId, to: element)
    }
    func register<V: View>(elementId: ElementID, to view: V) {
        storage.register(elementId: elementId, to: view)
    }
    
    func displayHasBeenRendered(_ elementID: ElementID) {
        storage.displayHasBeenRendered(elementID)
    }
    
    func updateRoot(with element: ElementID) {
        storage.updateRoot(with: element)
    }
    
    func updateRootDisplay(element: DisplayElement) {
        storage.updateRootDisplay(element: element)
    }
    
    func updateFrame(of elementID: ElementID, with frame: ElementFrame) {
        storage.updateFrame(of: elementID, with: frame)
    }
    
    func clearInvalidElements() {
        storage.clearInvalidElements()
    }
    
    func markAsInvalid(_ elementID: ElementID) {
        storage.markAsInvalid(elementID)
    }
    
    func markRootAsInvalid() {
        storage.markRootAsInvalid()
    }
    
    // TODO: https://github.com/apple/swift/blob/main/docs/OwnershipManifesto.md
    var invalidElements: Set<ElementID> { storage.invalidElements }
    var areThereInvalidElements: Bool { storage.areThereInvalidElements }
    
    var rootElement: Element? { storage.rootElement }
    var rootDisplay: DisplayElement? { storage.rootDisplay }
    var constraint: Size<Float> { storage.constraint }
    var areThereElements: Bool { storage.areThereElements }

    func addEnviroment(property: EnviromentProperty) -> Bool {
        storage.addEnviroment(property: property)
    }
    
    func removeEnviroment(property: EnviromentProperty) {
        storage.removeEnviroment(property: property)
    }
    
    func enviromentProperty(for id: ObjectIdentifier) -> EnviromentProperty? {
        storage.enviromentProperty(for: id)
    }
    
    var enviromentProperties: [EnviromentProperty] {
        storage.enviromentProperties
    }
}

extension Storable {
    var asAny: AnyStorable { AnyStorable(self) }
}

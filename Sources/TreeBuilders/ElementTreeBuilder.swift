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

protocol TreeElementBuilder {
    func buildElementTree(_ world: World) -> Element
}

// MARK: - Entrypoint

extension World {
    func generate<V: View>(_ rootView: V) {
        // Create al the elements in the tree.
        rootElement = ShinyUI.buildElementTree(rootView, self).elementID
        
        guard let rootElement = rootElement else {
            fatalError("Root element must not be nil something when wrong PANIC")
        }
        
        // Send the root layout in order to provide layout context.
        updateElementFrame(rootElement, .fromOrigin(screenSize))
    }
}

// MARK: - Main builder

extension World {
    /// Creates a new element using the type.
    ///
    /// - parameter elementType: The type of the element to be created.
    func createElement<T: Element>(_ elementType: T.Type,
                                   _ view: View) -> T {
        let element: T = elementType.init(ElementID.random())
        register(element, representedBy: view)
        return element
    }
}

/// Generates a new element from a view.
///
/// - parameters:
///         - view: The view used to create the `Element`.
///         - world: The world to store the references and elements.
///
/// - Note: This method should not be used to generate the root node, instead use `generate`.
///         otherwise the rootElement will not be set in the world.
func buildElementTree(_ view: View, _ world: World) -> Element {
    // Check if the view is a `TreeElementBuilder` in that case create a
    // element using the method buildElementTree. This chunk if important
    // if it fail it will redirect the flow directly to the child so we can
    // still have custom `View`s comming from user land and avoid force them
    // to implement `TreeElementBuilder`.
    if let elementBuilder = view as? TreeElementBuilder {
        return elementBuilder.buildElementTree(world)
    }
    
    let element: Element = buildElementTreeAndCheckStateReadAccess(view,
                                                                   world: world)
    
    // Wrap the body into a custom element.
    let customElement = world.createElement(CustomElement.self, view)
    world.link(child: element, toParent: customElement)
    
    return customElement
}

/// Generates a new element from a view.
///
/// - parameters:
///         - view: The view used to create the `Element`.
///         - parent: The owner of the child.
///         - world: The world to store the references and elements.
///
/// - Note: This method should not be used to generate the root node, instead use `generate`.
///         otherwise the rootElement will not be set in the world.
@discardableResult
func buildElementTree(_ view: View,
                      linkedTo parent: Element,
                      world: World) -> Element {
    let element: Element
    
    defer {
        world.register(element, representedBy: view)
        world.link(child: element, toParent: parent)
    }
    
    // Check if the view is a `TreeElementBuilder` in that case create a
    // element using the method buildElementTree, this chunk if important
    // if it fail it will redirect the flow directly to the child so we can
    // still have custom `View`s comming from user land and avoid force them
    // to implement `TreeElementBuilder`.
    if let elementBuilder = view as? TreeElementBuilder {
        // Request the element.
        element = elementBuilder.buildElementTree(world)
        return element
    }
    
    // Reset the invalidation state
    resetViewStateInvalidation(view)
    
    // If the view is not of that type it has to walk it to find the next
    // element buildable view.
    element = buildElementTree(view, world)
    
    return element
}

private func
buildElementTreeAndCheckStateReadAccess(_ view: View, world: World) -> Element {
    // Reset the state invalidation.
    // After a view is recreated read the states must be reseted so we know
    // if the body is reading any property.
    resetViewStateInvalidation(view)
    
    // Check if the invalidation should be performed, if there is a read diff
    // before and after the body is called it means the state is in use
    // so the `shouldInvalidate` must be turned activated.
    
    // Copy all view dynamic views in order to get the state.
    let properties: [DynamicProperty] = dynamicPropertyDumper(view: view)
    
    properties.bodyStartReading()
    
    // If the view is not of that type it has to walk it to find the next
    // element buildable view.
    let element: Element = buildElementTree(view.body, world)
    
    properties.bodyStopReading()
    
    // After creation check which state was read and mark it as an
    // invalidation candidate.
    properties.configureInvalidationAfterElementCreation()
    
    return element
}

// MARK: - Storages

/// Avoiding runtime magic.

func buildElementTree2(_ view: Storage2, _ world: World) -> Element {
    // Create needed elements.
    let storageElement = StorageElement(ElementID.random())
    let eA = ShinyUI.buildElementTree(view.a, world)
    let eB = ShinyUI.buildElementTree(view.b, world)
    
    // Register them in the world.
    world.register(storageElement, representedBy: view)
    
    // Link parent with children.
    world.link(children: [eA, eB], toParent: storageElement)
    
    // Return the storage element.
    return storageElement
}

func buildElementTree3(_ view: Storage3, _ world: World) -> Element {
    // Create parent element which will be the reference for the children.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, world)
    let eB = ShinyUI.buildElementTree(view.b, world)
    let eC = ShinyUI.buildElementTree(view.c, world)
    
    // Register them in the world.
    world.register(storageElement, representedBy: view)
    
    // Link parent with children.
    world.link(children: [eA, eB, eC], toParent: storageElement)
    
    // Return the storage element.
    return storageElement
}

func buildElementTree4(_ view: Storage4, _ world: World) -> Element {
    // Create parent element.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, world)
    let eB = ShinyUI.buildElementTree(view.b, world)
    let eC = ShinyUI.buildElementTree(view.c, world)
    let eD = ShinyUI.buildElementTree(view.d, world)
    
    // Register them in the world.
    world.register(storageElement, representedBy: view)
    
    // Link parent with children.
    world.link(children: [eA, eB, eC, eD], toParent: storageElement)
    
    // Return the storage element.
    return storageElement
}

func buildElementTree5(_ view: Storage5, _ world: World) -> Element {
    // Create parent element.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, world)
    let eB = ShinyUI.buildElementTree(view.b, world)
    let eC = ShinyUI.buildElementTree(view.c, world)
    let eD = ShinyUI.buildElementTree(view.d, world)
    let eE = ShinyUI.buildElementTree(view.e, world)
    
    // Register them in the world.
    world.register(storageElement, representedBy: view)
    
    // Link parent with children.
    world.link(children: [eA, eB, eC, eD, eE], toParent: storageElement)
    
    return storageElement
}

func buildElementTree6(_ view: Storage6, _ world: World) -> Element {
    // Create parent element.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, world)
    let eB = ShinyUI.buildElementTree(view.b, world)
    let eC = ShinyUI.buildElementTree(view.c, world)
    let eD = ShinyUI.buildElementTree(view.d, world)
    let eE = ShinyUI.buildElementTree(view.e, world)
    let eF = ShinyUI.buildElementTree(view.f, world)
    
    // Register them in the world.
    world.register(storageElement, representedBy: view)
    
    // Link parent with children.
    world.link(children: [eA, eB, eC, eD, eE, eF],
               toParent: storageElement)
    
    return storageElement
}

func buildElementTree7(_ view: Storage7, _ world: World) -> Element {
    // Create parent element.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, world)
    let eB = ShinyUI.buildElementTree(view.b, world)
    let eC = ShinyUI.buildElementTree(view.c, world)
    let eD = ShinyUI.buildElementTree(view.d, world)
    let eE = ShinyUI.buildElementTree(view.e, world)
    let eF = ShinyUI.buildElementTree(view.f, world)
    let eG = ShinyUI.buildElementTree(view.g, world)
    
    // Register them in the world.
    world.register(storageElement, representedBy: view)
    
    // Link parent with children.
    world.link(children: [eA, eB, eC, eD, eE, eF, eG],
               toParent: storageElement)
    
    return storageElement
}

func buildElementTree8(_ view: Storage8, _ world: World) -> Element {
    // Create parent element.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, world)
    let eB = ShinyUI.buildElementTree(view.b, world)
    let eC = ShinyUI.buildElementTree(view.c, world)
    let eD = ShinyUI.buildElementTree(view.d, world)
    let eE = ShinyUI.buildElementTree(view.e, world)
    let eF = ShinyUI.buildElementTree(view.f, world)
    let eG = ShinyUI.buildElementTree(view.g, world)
    let eH = ShinyUI.buildElementTree(view.h, world)
    
    // Register them in the world.
    world.register(storageElement, representedBy: view)
    
    world.link(children: [eA, eB, eC, eD, eE, eF, eG, eH],
               toParent: storageElement)
    
    return storageElement
}

func buildElementTree9(_ view: Storage9, _ world: World) -> Element {
    // Create parent element.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, world)
    let eB = ShinyUI.buildElementTree(view.b, world)
    let eC = ShinyUI.buildElementTree(view.c, world)
    let eD = ShinyUI.buildElementTree(view.d, world)
    let eE = ShinyUI.buildElementTree(view.e, world)
    let eF = ShinyUI.buildElementTree(view.f, world)
    let eG = ShinyUI.buildElementTree(view.g, world)
    let eH = ShinyUI.buildElementTree(view.h, world)
    let eI = ShinyUI.buildElementTree(view.i, world)
    
    // Register them in the world.
    world.register(storageElement, representedBy: view)
    
    world.link(children: [eA, eB, eC, eD, eE, eF, eG, eH, eI],
               toParent: storageElement)
    
    return storageElement
}

func buildElementTree10(_ view: Storage10, _ world: World) -> Element {
    // Create parent element.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, world)
    let eB = ShinyUI.buildElementTree(view.b, world)
    let eC = ShinyUI.buildElementTree(view.c, world)
    let eD = ShinyUI.buildElementTree(view.d, world)
    let eE = ShinyUI.buildElementTree(view.e, world)
    let eF = ShinyUI.buildElementTree(view.f, world)
    let eG = ShinyUI.buildElementTree(view.g, world)
    let eH = ShinyUI.buildElementTree(view.h, world)
    let eI = ShinyUI.buildElementTree(view.i, world)
    let eJ = ShinyUI.buildElementTree(view.j, world)
    
    // Register them in the world.
    world.register(storageElement, representedBy: view)
    
    world.link(children: [eA, eB, eC, eD, eE, eF, eG, eH, eI, eJ],
               toParent: storageElement)
    
    return storageElement
}

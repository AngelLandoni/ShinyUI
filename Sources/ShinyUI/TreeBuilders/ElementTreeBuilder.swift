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
    func buildElementTree<S: Storable>(_ storable: S) -> Element
}

// MARK: - Entrypoint

func generate<V: View, S: Storable>(rootView: V, in storable: S) {
    let rootElement = ShinyUI.buildElementTree(rootView, storable).elementID
    storable.updateRoot(with: rootElement)
    storable.updateFrame(of: rootElement,
                         with: .fromOrigin(storable.constraint))
}

// MARK: - Main builder

func createElement<T: Element, V: View, S: Storable>(type: T.Type,
                                                     with view: V,
                                                     in storable: S) -> T {
    let element: T = type.init(ElementID.random())
    register(element: element, representedBy: view, in: storable)
    return element
}

/// Generates a new element from a view.
///
/// - parameters:
///         - view: The view used to create the `Element`.
///         - world: The world to store the Boxerences and elements.
///
/// - Note: This method should not be used to generate the root node, instead use `generate`.
///         otherwise the rootElement will not be set in the world.
func buildElementTree<V: View, S: Storable>(_ view: V,
                                            _ storable: S) -> Element {
    // Check if the view is a `TreeElementBuilder` in that case create a
    // element using the method buildElementTree. This chunk if important
    // if it fail it will redirect the flow directly to the child so we can
    // still have custom `View`s comming from user land and avoid force them
    // to implement `TreeElementBuilder`.
    if let elementBuilder = view as? TreeElementBuilder {
        return elementBuilder.buildElementTree(storable)
    }

    let element: Element = buildElementTreeAndCheckStateReadAccess(
        view,
        storable: storable
    )

    // Wrap the body into a custom element.
    let customElement = createElement(type: CustomElement.self,
                                      with: view,
                                      in: storable)

    link(child: element, to: customElement, in: storable)

    return customElement
}

/// Generates a new element from a view.
///
/// - parameters:
///         - view: The view used to create the `Element`.
///         - parent: The owner of the child.
///         - world: The world to store the Boxerences and elements.
///         - replaceChild: A flag to indicate if the child must be replaced or added to the parent.
///
/// - Note: This method should not be used to generate the root node, instead use `generate`.
///         otherwise the rootElement will not be set in the world.
@discardableResult
func buildElementTree<V: View, S: Storable>(_ view: V,
                                            linkedTo parent: Element,
                                            storable: S,
                                            replaceChild: Bool = true) -> Element {
    let element: Element
    
    defer {
        register(element: element, representedBy: view, in: storable)
        if replaceChild {
            link(child: element, to: parent, in: storable)
        } else {
            link(addingChild: element, to: parent, in: storable)
        }
    }
    
    // Check if the view is a `TreeElementBuilder` in that case create a
    // element using the method buildElementTree, this chunk if important
    // if it fail it will redirect the flow directly to the child so we can
    // still have custom `View`s comming from user land and avoid force them
    // to implement `TreeElementBuilder`.
    if let elementBuilder = view as? TreeElementBuilder {
        // Request the element.
        element = elementBuilder.buildElementTree(storable)
        return element
    }
    
    // Reset the invalidation state
    resetViewStateInvalidation(view)
    
    // If the view is not of that type it has to walk it to find the next
    // element buildable view.
    element = buildElementTree(view, storable)
    
    return element
}

private func buildElementTreeAndCheckStateReadAccess<V: View, S: Storable>(
    _ view: V, storable: S) -> Element {
    // Reset the state invalidation.
    // After a view is recreated read the states must be reseted so we know
    // if the body is reading any property.
    resetViewStateInvalidation(view)
    
    // Check if the invalidation should be performed, if there is a read diff
    // before and after the body is called it means the state is in use
    // so the `shouldInvalidate` must be turned activated.

    // Copy all view dynamic views in order to get the state.
    let properties: [DynamicProperty] = dynamicPropertyDumper(view: view)
    // Extract all the enviroment variables.
    let enviromentProps = extractEnviromentProperties(in: view)
    
    // Add to the storable all the new enviroment variables if the enviroment
    // variable already exist update it.
    let added = addEnviroment(properties: enviromentProps, in: storable)
    
    properties.bodyStartReading()
    // If the view is not of that type it has to walk it to find the next
    // element buildable view.
    let element: Element = buildElementTree(view.body, storable)
    properties.bodyStopReading()
    
    removeEnviroment(properties: added, from: storable)

    // After creation check which state was read and mark it as an
    // invalidation candidateq.
    properties.configureInvalidationAfterElementCreation()

    return element
}

// MARK: - Storages

/// Avoiding runtime magic.

func
buildElementTree<V1: View, V2: View, S: Storable>(_ view: Storage2<V1, V2>,
                                                  _ storable: S) -> Element {
    // Create needed elements.
    let storageElement = StorageElement(ElementID.random())
    let eA = ShinyUI.buildElementTree(view.a, storable)
    let eB = ShinyUI.buildElementTree(view.b, storable)
    
    // Register them in the world.
    register(element: storageElement, representedBy: view, in: storable)

    // Link parent with children.
    link(children: [eA, eB], to: storageElement, in: storable)
    
    // Return the storage element.
    return storageElement
}

func buildElementTree<V1: View, V2: View, V3: View, S: Storable>(
    _ view: Storage3<V1, V2, V3>, _ storable: S) -> Element {
    // Create parent element which will be the Boxerence for the children.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, storable)
    let eB = ShinyUI.buildElementTree(view.b, storable)
    let eC = ShinyUI.buildElementTree(view.c, storable)

    // Register them in the world.
    register(element: storageElement, representedBy: view, in: storable)

    // Link parent with children.
    link(children: [eA, eB, eC], to: storageElement, in: storable)

    // Return the storage element.
    return storageElement
}

func buildElementTree<V1: View, V2: View, V3: View, V4: View, S: Storable>(
    _ view: Storage4<V1, V2, V3, V4>, _ storable: S) -> Element {
    // Create parent element.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, storable)
    let eB = ShinyUI.buildElementTree(view.b, storable)
    let eC = ShinyUI.buildElementTree(view.c, storable)
    let eD = ShinyUI.buildElementTree(view.d, storable)

    // Register them in the world.
    register(element: storageElement, representedBy: view, in: storable)

    // Link parent with children.
    link(children: [eA, eB, eC, eD], to: storageElement, in: storable)

    // Return the storage element.
    return storageElement
}

func buildElementTree<V1: View, V2: View, V3: View, V4: View, V5: View, S: Storable>(
    _ view: Storage5<V1, V2, V3, V4, V5>, _ storable: S) -> Element {
    // Create parent element.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, storable)
    let eB = ShinyUI.buildElementTree(view.b, storable)
    let eC = ShinyUI.buildElementTree(view.c, storable)
    let eD = ShinyUI.buildElementTree(view.d, storable)
    let eE = ShinyUI.buildElementTree(view.e, storable)

    // Register them in the world.
    register(element: storageElement, representedBy: view, in: storable)

    // Link parent with children.
    link(children: [eA, eB, eC, eD, eE], to: storageElement, in: storable)

    return storageElement
}

func buildElementTree<V1: View,
                      V2: View,
                      V3: View,
                      V4: View,
                      V5: View,
                      V6: View,
                      S: Storable>(
    _ view: Storage6<V1, V2, V3, V4, V5, V6>, _ storable: S) -> Element {
    // Create parent element.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, storable)
    let eB = ShinyUI.buildElementTree(view.b, storable)
    let eC = ShinyUI.buildElementTree(view.c, storable)
    let eD = ShinyUI.buildElementTree(view.d, storable)
    let eE = ShinyUI.buildElementTree(view.e, storable)
    let eF = ShinyUI.buildElementTree(view.f, storable)

    // Register them in the world.
    register(element: storageElement, representedBy: view, in: storable)

    // Link parent with children.
    link(children: [eA, eB, eC, eD, eE, eF], to: storageElement, in: storable)

    return storageElement
}

func buildElementTree<V1: View,
                      V2: View,
                      V3: View,
                      V4: View,
                      V5: View,
                      V6: View,
                      V7: View,
                      S: Storable>(
    _ view: Storage7<V1, V2, V3, V4, V5, V6, V7>,
    _ storable: S) -> Element {
    // Create parent element.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, storable)
    let eB = ShinyUI.buildElementTree(view.b, storable)
    let eC = ShinyUI.buildElementTree(view.c, storable)
    let eD = ShinyUI.buildElementTree(view.d, storable)
    let eE = ShinyUI.buildElementTree(view.e, storable)
    let eF = ShinyUI.buildElementTree(view.f, storable)
    let eG = ShinyUI.buildElementTree(view.g, storable)

    // Register them in the world.
    register(element: storageElement, representedBy: view, in: storable)

    // Link parent with children.
    link(children: [eA, eB, eC, eD, eE, eF, eG],
         to: storageElement,
         in: storable)
    
    return storageElement
}

func buildElementTree<V1: View,
                      V2: View,
                      V3: View,
                      V4: View,
                      V5: View,
                      V6: View,
                      V7: View,
                      V8: View,
                      S: Storable>(
    _ view: Storage8<V1, V2, V3, V4, V5, V6, V7, V8>,
    _ storable: S) -> Element {
    // Create parent element.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, storable)
    let eB = ShinyUI.buildElementTree(view.b, storable)
    let eC = ShinyUI.buildElementTree(view.c, storable)
    let eD = ShinyUI.buildElementTree(view.d, storable)
    let eE = ShinyUI.buildElementTree(view.e, storable)
    let eF = ShinyUI.buildElementTree(view.f, storable)
    let eG = ShinyUI.buildElementTree(view.g, storable)
    let eH = ShinyUI.buildElementTree(view.h, storable)

    // Register them in the world.
    register(element: storageElement, representedBy: view, in: storable)
    
    link(children: [eA, eB, eC, eD, eE, eF, eG, eH],
         to: storageElement,
         in: storable)

    return storageElement
}

func buildElementTree<V1: View,
                      V2: View,
                      V3: View,
                      V4: View,
                      V5: View,
                      V6: View,
                      V7: View,
                      V8: View,
                      V9: View,
                      S: Storable>(
    _ view: Storage9<V1, V2, V3, V4, V5, V6, V7, V8, V9>,
    _ storable: S) -> Element {
    // Create parent element.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, storable)
    let eB = ShinyUI.buildElementTree(view.b, storable)
    let eC = ShinyUI.buildElementTree(view.c, storable)
    let eD = ShinyUI.buildElementTree(view.d, storable)
    let eE = ShinyUI.buildElementTree(view.e, storable)
    let eF = ShinyUI.buildElementTree(view.f, storable)
    let eG = ShinyUI.buildElementTree(view.g, storable)
    let eH = ShinyUI.buildElementTree(view.h, storable)
    let eI = ShinyUI.buildElementTree(view.i, storable)

    // Register them in the world.
    register(element: storageElement, representedBy: view, in: storable)

    link(children: [eA, eB, eC, eD, eE, eF, eG, eH, eI],
         to: storageElement,
         in: storable)

    return storageElement
}

func buildElementTree<V1: View,
                      V2: View,
                      V3: View,
                      V4: View,
                      V5: View,
                      V6: View,
                      V7: View,
                      V8: View,
                      V9: View,
                      V10: View,
                      S: Storable>(
    _ view: Storage10<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10>,
    _ storable: S) -> Element {
    // Create parent element.
    let storageElement = StorageElement(ElementID.random())
    // Create children elements.
    let eA = ShinyUI.buildElementTree(view.a, storable)
    let eB = ShinyUI.buildElementTree(view.b, storable)
    let eC = ShinyUI.buildElementTree(view.c, storable)
    let eD = ShinyUI.buildElementTree(view.d, storable)
    let eE = ShinyUI.buildElementTree(view.e, storable)
    let eF = ShinyUI.buildElementTree(view.f, storable)
    let eG = ShinyUI.buildElementTree(view.g, storable)
    let eH = ShinyUI.buildElementTree(view.h, storable)
    let eI = ShinyUI.buildElementTree(view.i, storable)
    let eJ = ShinyUI.buildElementTree(view.j, storable)

    // Register them in the world.
    register(element: storageElement, representedBy: view, in: storable)
    
    link(children: [eA, eB, eC, eD, eE, eF, eG, eH, eI, eJ],
         to: storageElement,
         in: storable)

    return storageElement
}

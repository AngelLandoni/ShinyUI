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

protocol TreeDisplayElementBuilder {
    func buildDisplayElementTree(_ world: World,
                                 _ host: DisplayElement)
}

// MARK: - Main builder

extension World {
    /// Creates a new element using the type.
    ///
    /// - parameter elementType: The type of the element to be created.
    func createDisplayElement<T: DisplayElement>(
        _ displayElementType: T.Type,
        _ element: Element
    ) -> T {
        let displayElement: T = displayElementType.init()
        registerDisplay(displayElement, element.elementID)
        return displayElement
    }
}

// MARK: - Entrypoint

extension World {
    /// Iterates over all the elements and generate the displays for each of them.
    ///
    /// - Parameter host: The element used as an anchor point to show all the tree.
    func render(_ host: DisplayElement) {
        guard let rootElementID = rootElement else {
            fatalError("World does not have an element root ID")
        }
        guard let rootElement = elements[rootElementID] else {
            fatalError("""
                World does not have an element with id: \(rootElementID)
            """)
        }
        rootDisplayElement = host
        buildDisplayElementTree(rootElement, self, host)
    }
}

func buildDisplayElementTree(_ element: ElementID,
                             _ world: World,
                             _ host: DisplayElement) {
    guard let element = world.element(for: element) else {
        fatalError(ErrorMessages.elementNotFound)
    }
    buildDisplayElementTree(element, world, host)
}

func buildDisplayElementTree(_ element: Element,
                             _ world: World,
                             _ host: DisplayElement) {

    defer {
        world.displayAsBeenRendered(element.elementID)
    }

    // Check if the element is renderable if it is call the render method
    // to get the renderable component.
    if let displayElementBuilder = element as? TreeDisplayElementBuilder {
        return displayElementBuilder.buildDisplayElementTree(world, host)
    }

    // If the element is not visual representable it has to derive the
    // process to the child.
    if let elementChildren = world.children(of: element.elementID) {
        return buildDisplayElementTree(elementChildren, world, host)
    }
}

/// Build the display element.
///
/// - Note: This function derives into the `buildDisplayElementTree` function to generate the
///         display.
func buildDisplayElementTree(_ elements: OrderedSet<ElementID>,
                             _ world: World,
                             _ host: DisplayElement) {
    // Iterate over each child create and force the render inside a host.
    for child in elements {
        // Look for the element in the world.
        guard let child: Element = world.elements[child] else { continue }
        // Build the display for the element.
        buildDisplayElementTree(child, world, host)
    }
}

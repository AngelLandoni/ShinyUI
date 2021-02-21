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

final class NavigationElement: LeafElement {
    var elementID: ElementID
    var context: NavigationContext?

    init(_ elementID: ElementID) {
        self.elementID = elementID
    }
}

// MARK: TreeElementBuilder

extension Navigation: TreeElementBuilder {
    func buildElementTree<S: Storable>(_ storable: S) -> Element {
        let element = createElement(type: NavigationElement.self,
                                    with: self,
                                    in: storable)
        // Create a new navigation context.
        element.context = NavigationContext(storable: AnyStorable(storable),
                                            parent: element)
        // Context must be unwrapped before creating the enviroment otherwise
        // the type of the Enviroment will be Optional<NavigationContext> and
        // the search by indentifier will fail.
        let newEnviromentProp = Enviroment(wrappedValue: element.context!)
        // Send the enviroment prop to the store to be saved or updated.
        let propsAdded = addEnviroment(properties: [newEnviromentProp],
                                       in: storable)
        
        ShinyUI.buildElementTree(body, linkedTo: element, storable: storable)
        
        // Remove the property to not affect other branches.
        removeEnviroment(properties: propsAdded, in: storable)
        
        return element
    }
}

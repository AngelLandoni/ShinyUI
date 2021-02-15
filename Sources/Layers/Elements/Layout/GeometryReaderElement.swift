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

final class GeometryReaderElement: Element {
    var elementID: ElementID

    var contentBuilder: ((Size<Float>) -> Element)?

    init(_ elementID: ElementID) {
        self.elementID = elementID
    }
}

extension GeometryReader: TreeElementBuilder {
    /// TODO: Change creation way avoid the element generate a unique entity
    /// which carries an enum with payload.
    /// let elementID = world.createElement(ofType: .geometryReader(size))
    func buildElementTree<S: Storable>(_ storable: S) -> Element {
        let element = createElement(type: GeometryReaderElement.self,
                                    with: self,
                                    in: storable)
        // Inverse the order, when the layout finish the calculation force
        // the creation of the child element only at that point it knows the
        // geometry.
        element.contentBuilder = { size in
            ShinyUI.buildElementTree(content(size), storable)
        }
        // The body must not be generated, that will be generated after layout.
        return element
    }
}

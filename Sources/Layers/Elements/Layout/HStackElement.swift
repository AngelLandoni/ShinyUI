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

final class HStackElement: Element {
    /// A which matches with the view contrapart.
    var elementID: ElementID
    /// Contains the alignment.
    var alignment: VerticalAlignment = .start
    /// Contains the spacing.
    var spacing: Float = 0

    /// Creates a new instance of `VStackElement` providing an `ElementID`.
    ///
    /// - Note: This method is mandatory for each `Element`.
    init(_ elementID: ElementID) {
        self.elementID = elementID
    }
}

// MARK: - TreeElementBuilder

extension HStack: TreeElementBuilder {
    func buildElementTree(_ world: World) -> Element {
        // Create a new `VStackElement` and register it in the world.
        let element: HStackElement = world.createElement(HStackElement.self,
                                                         self)
        element.alignment = alignment
        element.spacing = spacing

        // Build element tree for children.
        ShinyUI.buildElementTree(body, linkedTo: element, world: world)

        return element
    }
}

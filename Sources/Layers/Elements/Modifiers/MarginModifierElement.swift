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

final class MarginModifierElement: Element {
    var elementID: ElementID

    var left: Float = 0
    var right: Float = 0
    var top: Float = 0
    var bottom: Float = 0

    init(_ elementID: ElementID) {
        self.elementID = elementID
    }
}

// MARK: - TreeElementBuilder

extension MarginModifier: TreeElementBuilder {
    func buildElementTree(_ world: World) -> Element {
        let element = world.createElement(MarginModifierElement.self, self)

        for side in sides {
            switch side {
            case .left(let value):
                element.left = value
            case .right(let value):
                element.right = value
            case .top(let value):
                element.top = value
            case .bottom(let value):
                element.bottom = value

            case .horizontal(let value):
                element.left = value
                element.right = value
            case .vertical(let value):
                element.top = value
                element.bottom = value

            case .all(let value):
                element.left = value
                element.right = value
                element.top = value
                element.bottom = value
            }
        }

        ShinyUI.buildElementTree(body, linkedTo: element, world: world)
        return element
    }
}

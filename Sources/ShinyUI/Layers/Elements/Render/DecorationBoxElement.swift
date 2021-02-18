//
//  File.swift
//  
//
//  Created by Angel Landoni on 27/1/21.
//

final class DecorationBoxElement: Element {
    var elementID: ElementID

    var decorations: [DecorationProperty] = []

    init(_ elementID: ElementID) {
        self.elementID = elementID
    }
}

// MARK: - TreeElementBuilder

extension DecorationBox: TreeElementBuilder {
    func buildElementTree<S: Storable>(_ storable: S) -> Element {
        let element = createElement(type: DecorationBoxElement.self,
                                    with: self,
                                    in: storable)
        element.decorations = decorations
        ShinyUI.buildElementTree(body, linkedTo: element, storable: storable)
        return element
    }
}

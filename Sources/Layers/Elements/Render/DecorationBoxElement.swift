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
    func buildElementTree(_ world: World) -> Element {
        let element = world.createElement(DecorationBoxElement.self, self)
        element.decorations = decorations
        ShinyUI.buildElementTree(body, linkedTo: element, world: world)
        return element
    }
}

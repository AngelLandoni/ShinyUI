//
//  File.swift
//  
//
//  Created by Angel Landoni on 30/1/21.
//

final class ImageElement: LeafElement {
    var elementID: ElementID

    var path: String = ""
    var fit: Fit = .scaleToFill

    init(_ elementID: ElementID) {
        self.elementID = elementID
    }
}

// MARK: TreeElementBuilder

extension Image: TreeElementBuilder {
    func buildElementTree(_ world: World) -> Element {
        let element: ImageElement = world.createElement(ImageElement.self, self)
        element.path = path
        element.fit = fit
        return element
    }
}

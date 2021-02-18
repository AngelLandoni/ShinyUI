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
    func buildElementTree<S: Storable>(_ storable: S) -> Element {
        let element = createElement(type: ImageElement.self,
                                    with: self,
                                    in: storable)
        element.path = path
        element.fit = fit
        return element
    }
}

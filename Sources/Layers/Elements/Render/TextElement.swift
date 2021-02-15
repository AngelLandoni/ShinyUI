//
//  File.swift
//  
//
//  Created by Angel Landoni on 28/12/20.
//

/// A virtual text element.
final class TextElement: LeafElement {
    var elementID: ElementID

    var color: Color = Color(0xFFFFFF)
    var foregroundColor: Color = Color(0x000000)
    var text: String = ""
    var fontSize: Float = 17
    var numberOfLines: UInt = 0

    init(_ elementID: ElementID) {
        self.elementID = elementID
    }
}

// MARK: TreeElementBuilder

extension Text: TreeElementBuilder {
    func buildElementTree<S: Storable>(_ storable: S) -> Element {
        var color: Color = Color(0xFFFFFF)
        var foregroundColor: Color = Color(0x000000)
        var fontSize: Float = 17
        var numberOfLines: UInt = 0

        for style in styles {
            switch style {
            case .color(let colorStyle):
                color = colorStyle
            case .foregroundColor(let color):
                foregroundColor = color
            case .font(let fontName, let size):
                fontSize = size
            case .numberOfLines(let numberOfLinesStyle):
                numberOfLines = numberOfLinesStyle
            }
        }

        // TODO: Instead of register the element inside the create element
        // to that inside the element tree builder.
        let element: TextElement = createElement(type: TextElement.self,
                                                 with: self,
                                                 in: storable)
        element.text = title
        element.color = color
        element.fontSize = fontSize
        element.numberOfLines = numberOfLines
        element.foregroundColor = foregroundColor
        return element
    }
}

//
//  ContainerDisplayElement.swift
//  
//
//  Created by Angel Landoni on 19/2/21.
//

#if canImport(UIKit)
import UIKit

final class ContainerDisplayElement: UIView, DisplayElement {

    func updateFrame(_ frame: ElementFrame) {
        self.frame = frame.asFrame
    }

    func submit(_ displayElement: DisplayElement) {
        isUserInteractionEnabled = true
        addSubview(displayElement.getView())
    }

    func remove() {
        removeFromSuperview()
    }

    func getView() -> UIView { return self }
}

#endif

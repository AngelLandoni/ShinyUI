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

#if canImport(CoreGraphics)
import QuartzCore
import UIKit

private final class DecorationBoxDisplayElement: DisplayElement {

    fileprivate let view: UIView = UIView()

    // MARK: Lifecycle

    init() {}

    // MARK: DisplayElement

    func updateFrame(_ frame: ElementFrame) {
        view.frame = frame.asFrame
    }

    func submit(_ displayElement: DisplayElement) {
        view.addSubview(displayElement.getView())
    }

    func remove() {
        view.removeFromSuperview()
    }

    func getView() -> UIView {
        return view
    }
}

extension DecorationBoxElement: TreeDisplayElementBuilder {
    func buildDisplayElementTree<S: Storable>(_ storable: S, _ host: DisplayElement) {
        let display = createDisplayElement(type: DecorationBoxDisplayElement.self,
                                           for: self,
                                           in: storable)

        if let frame = getFrame(storable) {
            display.updateFrame(frame)
        }

        for decoration in decorations {
            switch decoration {
            case .color(let color):
                display.view.backgroundColor = color.uiColor
            case .borderWidth(let width):
                display.view.layer.borderWidth = CGFloat(width)
            case .borderColor(let color):
                display.view.layer.borderColor = color.uiColor.cgColor
            case .cornerRadius(let radius):
                display.view.layer.cornerRadius = CGFloat(radius)
            case .shadow(let shadowDecorations):
                display.view.layer.shadowOpacity = 1
                // TODO: Slow, fix me.
                for decoration in shadowDecorations {
                    switch decoration {
                    case .offset(let offset):
                        display.view.layer.shadowOffset = CGSize(
                            width: CGFloat(offset.x),
                            height: CGFloat(offset.y)
                        )
                    case .color(let color):
                        display.view.layer.shadowColor = color.uiColor.cgColor
                    case .radius(let radius):
                        display.view.layer.shadowRadius = CGFloat(radius)
                    }
                }
            }
        }

        host.submit(display)

        let child = getChildElementId(for: elementID, in: storable)
        ShinyUI.buildDisplayElementTree(child, storable, display)
    }
}

#endif

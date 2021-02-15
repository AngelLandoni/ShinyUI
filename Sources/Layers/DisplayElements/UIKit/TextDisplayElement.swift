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

private final class TextDisplayElement: DisplayElement {

    fileprivate let view: UILabel = UILabel()

    // MARK: DisplayElement

    func updateFrame(_ frame: ElementFrame) {
        view.frame = frame.asFrame
    }

    func submit(_ displayElement: DisplayElement) {
        fatalError("TextDisplayElement can not host any display element")
    }

    func remove() {
        view.removeFromSuperview()
    }

    func getView() -> UIView {
        view
    }
}

extension TextElement: TreeDisplayElementBuilder {
    func buildDisplayElementTree<S: Storable>(_ storable: S, _ host: DisplayElement) {
        let displayText = createDisplayElement(type: TextDisplayElement.self,
                                               for: self,
                                               in: storable)
        
        if let frame = getFrame(storable) {
            displayText.updateFrame(frame)
        }

        displayText.view.font = UIFont.systemFont(ofSize: fontSize.cgFloat)
        displayText.view.textColor = foregroundColor.uiColor
        displayText.view.backgroundColor = color.uiColor
        displayText.view.text = text

        host.submit(displayText)
    }
}

#endif

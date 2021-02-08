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

#if canImport(UIKit)
import  UIKit

final class TapGestureDisplayElement: DisplayElement {
    
    let wrapper: UIView = UIView()
    var gesture: UITapGestureRecognizer?
    var onTap: (() -> Void)?
    
    func configure() {
        gesture = UITapGestureRecognizer(target: self,
                                         action: #selector(onTapHandler))
        gesture!.numberOfTapsRequired = 1
        wrapper.addGestureRecognizer(gesture!)
        wrapper.isUserInteractionEnabled = true
    }
    
    func updateFrame(_ frame: ElementFrame) {
        wrapper.frame = frame.asFrame
    }
    
    func submit(_ displayElement: DisplayElement) {
        wrapper.addSubview(displayElement.getView())
    }
    
    func remove() {
        wrapper.removeFromSuperview()
    }
    
    func getView() -> UIView {
        wrapper
    }
    
    @objc private func onTapHandler(touch: UITapGestureRecognizer) {
        onTap?()
    }
}

extension TapGestureModifierElement: TreeDisplayElementBuilder {
    func buildDisplayElementTree(_ world: World, _ host: DisplayElement) {
        let display = world.createDisplayElement(TapGestureDisplayElement.self,
                                                 self)
        host.submit(display)
        
        display.onTap = action
        display.configure()
        
        let child = getChildElementId(for: elementID, in: world)
        ShinyUI.buildDisplayElementTree(child, world, display)
    }
}

#endif

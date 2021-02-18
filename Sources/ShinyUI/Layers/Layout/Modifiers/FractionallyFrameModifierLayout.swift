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

extension FractionallyFrameModifierElement: Layout {
    func layout<S: Storable>(_ constraint: Size<Float>, _ storable: S) {
        let child = getChildElementId(for: elementID, in: storable)

        let fWidth: Float
        let fHeight: Float
        if let width = width {
            fWidth = (constraint.width * width) / 100
        } else {
            fWidth = constraint.width
        }

        if let height = height {
            fHeight = (constraint.height * height) / 100
        } else {
            fHeight = constraint.height
        }

        let childConstraint = Size(width: fWidth, height: fHeight)

        guard let childFrame = tryLayout(the: child,
                                         with: childConstraint,
                                         in: storable) else {
            fatalError(ErrorMessages.childCannotBeMeasured)
        }

        var selfFrame: ElementFrame = getFrame(storable) ?? .fromOrigin(.zero)

        let finalWidth: Float = width != nil ? fWidth : childFrame.size.width
        let finalHeight = height != nil ? fHeight : childFrame.size.height

        selfFrame.size = Size(width: finalWidth, height: finalHeight)
        storable.updateFrame(of: child, with: selfFrame)

        setFrame(storable, frame: selfFrame)
    }
}

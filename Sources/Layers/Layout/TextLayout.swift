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
import UIKit

extension TextElement: Layout {
    func layout(_ constraint: Size<Float>, _ world: World) {

        var selfFrame = getFrame(world) ?? .fromOrigin(.zero)

        // Calculates the text width, if the constraint width is bigger than
        // the required width the size will be set to that specific width
        // and height.
        let unboundedWidth = text.width(
            withConstrainedHeight: constraint.height,
            font: UIFont.systemFont(ofSize: CGFloat(fontSize))
        )

        // Checks if the size of the text fits.
        if unboundedWidth <= constraint.width {
            // Calcualtes the height based on the needed width.
            let boundedHeight = text.height(
                withConstrainedWidth: unboundedWidth,
                font: UIFont.systemFont(ofSize: CGFloat(fontSize))
            )

            selfFrame.size = Size(width: unboundedWidth, height: boundedHeight)
            // Submit the size.
            setFrame(world, frame: selfFrame)
            return
        }

        // Calculates the height based on bounded width (AKA multiline).
        let boundedHeight = text.height(
            withConstrainedWidth: constraint.width,
            font: UIFont.systemFont(ofSize: CGFloat(fontSize))
        )

        selfFrame.size = Size(width: constraint.width, height: boundedHeight)

        // Sets a new frame for the text.
        setFrame(world, frame: selfFrame)
    }
}

#endif

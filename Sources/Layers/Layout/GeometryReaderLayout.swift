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

/// FIXME: The geometry reader must be the last item in the stack to be calculated (in order to get the
/// size of the element below it)
/// FIXME: For some reason when the layout is recalculated the display disappears and it is not possible
/// to see anything.
extension GeometryReaderElement: Layout {
    func layout<S: Storable>(_ constraint: Size<Float>, _ storable: S) {
        // Create the elements in this specific moment.
        guard let child: Element = contentBuilder?(constraint) else { return }
        // Change flag to true to propagate the correct layout, false to
        // match SwiftUI behavior.
        #if true
        guard let childFrame = tryLayout(the: child.elementID,
                                         with: constraint,
                                         in: storable) else { return }
        #else
        guard let _ = child.tryLayout(constraint, world) else { return }
        #endif

        link(child: child, to: self, in: storable)

        // For some reason SwiftUI makes the GeometryReader as the size of the
        // constraint.
        let selfFrame = getFrame(storable)
        // Change flag to false to have to correct layout otherwise it will
        // match SwiftUI layout.
        #if true
        let newSelfFrame = ElementFrame(position: selfFrame?.position ?? .zero,
                                        size: Size(width: childFrame.size.width,
                                                   height: constraint.height))
        #else
        let newSelfFrame = ElementFrame(position: selfFrame?.position ?? .zero,
                                        size: constraint)
        #endif

        setFrame(storable, frame: newSelfFrame)
        shiftPosition(to: child.elementID,
                      in: storable,
                      shift: newSelfFrame.position)
    }
}

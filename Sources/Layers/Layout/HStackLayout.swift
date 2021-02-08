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

extension HStackElement: Layout {
    /// HStack is backed by a sorage element so we have to get the elements from there.
    func layout(_ constraint: Size<Float>, _ world: World) {
        var spacers: Set<Int> = []
        // The width that the elements need to be rendered.
        var remainingSpace: Float = constraint.width
        // Holds the biggest element height. This var is used to align vertically
        // the elements.
        var maxHeight: Float = 0

        // Check if the only child is the storage, it contains the children.
        guard let storageElementID = world.children(of: elementID)?.first else {
            fatalError("VStack must contains a only child the StorageElement")
        }
        // Extract children id, no children nothing to calculate.
        // The stack contains always only one child a StorageElement the
        // children should be extracted from there.
        guard let children = world.children(of: storageElementID) else {
            fatalError("VStack does not contain any children to layout")
        }

        var childElements: [Element] = []

        // Calculate the size for each element.
        for (index, elementID) in children.enumerated() {
            guard let childElement: Element = world.element(for: elementID)
                else { continue }

            defer { childElements.append(childElement) }

            // Avoid spacers.
            if childElement is SpacerElement {
                spacers.insert(index)
                continue
            }

            // Every time a child is calculated the rest of the children will
            // have less space to grow..
            let childConstraint = Size(width: remainingSpace,
                                       height: constraint.height)

            guard let childFrame = tryLayout(the: elementID,
                                             with: childConstraint,
                                             in: world) else { continue }

            maxHeight = max(childFrame.size.height, maxHeight)
            remainingSpace -= childFrame.size.width
        }

        let spacerWidth: Float = remainingSpace / Float(spacers.count)
        let selfFrame: ElementFrame = getFrame(world) ?? .fromOrigin(.zero)

        // Contains the next position that the child should take.
        // This is changed based on the previous child width, margins and spacers.
        var targetXOffsetForChild: Float = selfFrame.position.x

        for (index, childElement) in childElements.enumerated() {
            if spacers.contains(index) {
                targetXOffsetForChild += spacerWidth
                continue
            }

            guard let childFrame: ElementFrame = childElement.getFrame(world)
                else { continue }

            let yOffset: Float

            switch alignment {
            case .start:
                yOffset = 0
            case .center:
                yOffset = (maxHeight - childFrame.size.height) / 2
            case .end:
                yOffset = (maxHeight - childFrame.size.height)
            }

            let deltaX = targetXOffsetForChild - childFrame.position.x
            let deltaY = yOffset - childFrame.position.y

            shiftPosition(to: childElement.elementID,
                          in: world,
                          shift: Point(x: deltaX,
                                       y: deltaY + selfFrame.position.y))

            targetXOffsetForChild += childFrame.size.width
        }

        // Finally self update the size with the correct one after layout
        // all the children.
        var currentStackFrame = getFrame(world) ?? .fromOrigin(.zero)

        // Subtract parent position offset to get the real size of the stack.
        let stackWidth: Float = targetXOffsetForChild - selfFrame.position.x
        let stackHeight: Float = maxHeight

        currentStackFrame.size = Size(width: stackWidth, height: stackHeight)

        setFrame(world, frame: currentStackFrame)
    }
}

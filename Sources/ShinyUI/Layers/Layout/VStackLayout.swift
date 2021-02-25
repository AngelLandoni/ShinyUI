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

extension VStackElement: Layout {
    /// VStack is backed by a sorage element so we have to get the elements from there.
    func layout<S: Storable>(_ constraint: Size<Float>, _ storable: S) {
        // Check if the only child is the storage, it contains the children.
        guard let storageElement = storable.children(of: elementID)?.first else {
            fatalError("VStack must contains a only child the StorageElement")
        }
        // Get the children from the storage.
        // TODO: VStack does not support single child.
        guard let children = storable.children(of: storageElement) else {
            fatalError("VStack does not contain any children to layout")
        }
        
        assert(children.count != 1, "VStack does not support one child yet")
        
        // Store a temp Boxerence to the child to not find it again.
        var tempChilBox: [Element] = []
        
        var spacers: Set<Int> = []
        // Used to position the element in the Y axis depending the number of
        // elements iterated.
        var yOffset: Float = 0
        // Contains the max width from all the children.
        var biggestWidth: Float = 0
        
        // Get self position, if there is not position for the element
        // create a new one in the origin.
        let selfFrame: ElementFrame = getFrame(storable) ?? .fromOrigin(.zero)
        
        // Iterate over each children to get the elements and trigger
        // the layout.
        for (index, child) in children.enumerated() {
            // Get the child element form the world.
            guard let childElement = storable.element(for: child) else { continue }
            
            // Store it in the temp array got use it later.
            tempChilBox.append(childElement)
            
            // Avoid spacers.
            if childElement is SpacerElement {
                spacers.insert(index)
                continue
            }
            
            // Create the frame with the correct position for the current child.
            // in order to have a Boxerecen when creating it (this fixes a
            // specific problem related with stack inside stack).
            storable.updateFrame(
                of: child,
                with: .zeroSize(
                    Point(x: selfFrame.position.x,
                          y: yOffset + selfFrame.position.y)))
            
            // Trigger child layout.
            // For each child the constraint is getting less and less due
            // each child needs their own space.
            let remainingConstraint = Size(width: constraint.width,
                                           height: constraint.height - yOffset)
            
            guard tryLayout(the: child,
                            with: remainingConstraint,
                            in: storable) != nil else { continue }
            guard var currentFrameCopy = childElement.getFrame(storable)
            else { return }
            
            // Check if the size of the current child is bigger if not
            // just keep the same one.
            biggestWidth = max(biggestWidth, currentFrameCopy.size.width)
            
            // Set the offset coordinates adding the position of the stack.
            currentFrameCopy.position.y = selfFrame.position.y + yOffset
            currentFrameCopy.position.x = selfFrame.position.x
            
            // Force the position for the element.
            childElement.setFrame(storable, frame: currentFrameCopy)
            
            // Add the size of the current element.
            yOffset += currentFrameCopy.size.height
        }
        
        let spacerSize = (constraint.height - yOffset) / Float(spacers.count)
        var shiftOffset: Float = 0
        
        for (index, child) in tempChilBox.enumerated() {
            // Ignore the spacer and increate the shift offset.
            if spacers.contains(index) {
                shiftOffset += spacerSize
                continue
            }
            
            // Get the child width if it is possible if not just ignore it.
            guard let childFrame = child.getFrame(storable) else { continue }
            
            // Stores the horizontal position of the child, this variable
            // exists only to keep the horizontal line shorter =D.
            let hPosition: Float
            
            // Calculates horizontal position.
            switch alignment {
            case .center:
                hPosition = (biggestWidth - childFrame.size.width) / 2
            case .start:
                hPosition = 0
            case .end:
                hPosition = biggestWidth - childFrame.size.width
            }
            
            let deltaX = hPosition - childFrame.position.x
            
            // Update the child frame with the new one.
            shiftPosition(to: child.elementID,
                          in: storable,
                          shift: Point(x: deltaX + selfFrame.position.x,
                                       y: shiftOffset))
        }
        
        // Finally self update the size with the correct one after layout
        // all the children.
        var currentStackFrame = getFrame(storable) ?? .fromOrigin(.zero)
        
        // As it is doing the calculation comparing
        // at the beginning and not the end the last child adds its own
        // size to the offset so at the end the variable contains the
        // height of all the children.
        currentStackFrame.size = Size(width: biggestWidth,
                                      height: yOffset + shiftOffset)
        
        setFrame(storable, frame: currentStackFrame)
    }
}

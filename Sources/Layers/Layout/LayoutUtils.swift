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

/// Force a position shift over an element, the shift is triggered recursively till the the there is not more
/// children to iterate.
///
/// Maybe use the heap instead of the stack (no recursion).
///
/// - Parameters:
///     - element: The root `Element` to be shifted.
///     - in: The element source.
///     - shift: The value used to shift the `Element`.
///
func shiftPosition<S: Storable>(to elementID: ElementID,
                   in storable: S,
                   shift: Point<Float>) {
    // Shift the root.
    if var currentElementFrame: ElementFrame = storable.frame(of: elementID) {
        currentElementFrame.position.x += shift.x
        currentElementFrame.position.y += shift.y
        // Force update the element frame.
        storable.updateFrame(of: elementID, with: currentElementFrame)
    }

    guard let element = storable.element(for: elementID) else {
        // TBD: In case of an OptionalElement (if statement) the should the
        // elementId be deleted from the parent?
        // fatalError(ErrorMessages.elementNotFound)
        return
    }

    // Avoid propagation if the element is a stopper.
    guard !(element is ShiftPropagationStopper) else { return }

    // Shift the children.
    guard let children: OrderedSet<ElementID> = storable.children(of: elementID)
        else { return }

    for child in children {
        shiftPosition(to: child, in: storable, shift: shift)
    }
}

/// Try to measure an `Element` using the `ElementID`.
///
/// - Parameters:
///     - by: The `ElementID` to be measured.
///     - with: The constraint.
///     - in: The element source.
///
@discardableResult
func tryLayout<S: Storable>(the elementID: ElementID,
                            with constraint: Size<Float>,
                            in storable: S) -> ElementFrame? {
    guard storable.element(for: elementID) != nil
    else { fatalError(ErrorMessages.elementNotFound) }
    
    let element = storable.element(for: elementID)
    guard let layoutElement = element as? Layout else { return nil }
    
    layoutElement.layout(constraint, storable)
    return storable.frame(of: elementID)
}

/// Measure the provided `Element` using the `ElementID`.
///
/// - Parameters:
///     - element: The `ElementID` to be measured.
///     - in: The Word data source.
///
func layout<S: Storable>(element: ElementID, in storable: S) {
    guard let element = storable.element(for: element) else {
        fatalError(ErrorMessages.elementNotFound)
    }
    guard let layoutElement = element as? Layout else { return }
    layoutElement.layout(storable.constraint, storable)
}

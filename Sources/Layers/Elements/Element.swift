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

/// Represents a virtual element in the Element tree, this is used to track states and do sync from the
/// `View` to the `DisplayElement`.
/// Also this is in change of handle the element swap and updating.
///
/// This is a internal protocol should not be exposed outside the framework.
///
/// - Note: This is very similar to Flutter, to more information check flutter doc.
protocol Element {
    /// An unique id for each `View` element.
    ///
    /// - Note: This is used to know if the `View` tree changes and which element can be
    ///         reused.
    var elementID: ElementID { get set }

    init(_ elementID: ElementID)
}

// MARK: - Leaf

/// Represents the last element in the tree.
/// This should never have a child.
///
/// - Note: The Element behaves the same as the `Element` but the child variable is not accesible.
protocol LeafElement: Element { }

// MARK: - Layout Utils

extension Element {
    /// Returns the Element's frame.
    /// If the frame does not exits it just return nil.
    ///
    /// - Parameter world: The world which contains the information.
    /// - Returns: Maybe the 'Element''s frame or maybe not (Nil).
    func getFrame(_ world: World) -> ElementFrame? {
        guard self is Layout else { return nil }
        return world.frames[elementID]
    }

    /// Sets the new frame for the element in the provided `World`.
    ///
    /// - Parameter world: The world used to store the information.
    func setFrame(_ world: World, frame: ElementFrame) {
        guard self is Layout else { return }
        world.updateElementFrame(elementID, frame)
    }
}

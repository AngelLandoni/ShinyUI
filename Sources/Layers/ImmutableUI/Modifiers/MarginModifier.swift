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

/// TBD: Change name to Edge.
public enum Edge<T> {
    case left(T)
    case right(T)
    case top(T)
    case bottom(T)

    case horizontal(T)
    case vertical(T)

    case all(T)
}

/// Check `DecorationProperty` for more information.
public func left(_ edge: Float) -> Edge<Float> { .left(edge) }
public func right(_ edge: Float) -> Edge<Float> { .right(edge) }
public func top(_ edge: Float) -> Edge<Float> { .top(edge) }
public func bottom(_ edge: Float) -> Edge<Float> { .bottom(edge) }

public func horizontal(_ edge: Float) -> Edge<Float> { .horizontal(edge) }
public func vertical(_ edge: Float) -> Edge<Float> { .vertical(edge) }

public func all(_ edge: Float) -> Edge<Float> { .all(edge) }

public struct MarginModifier<Content: View>: View {
    /// Contains the content node.
    private let content: Content

    // TBD: Maybe move this to an option set?
    public let sides: [Edge<Float>]

    // MARK: Lifecycle

    public init(_ sides: [Edge<Float>] = [.all(0)],
                @ViewBuilder _ contentBuilder: () -> Content) {
        self.content = contentBuilder()
        self.sides = sides
    }

    public init(_ sides: [Edge<Float>] = [.all(0)],
                _ content: Content) {
        self.content = content
        self.sides = sides
    }

    // MARK: View

    public var body: some View { content }
}

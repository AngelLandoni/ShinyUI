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

public enum ShadowDecoration {
    case offset((x: Float, y: Float))
    case color(Color)
    case radius(Float)
}

public func offset(x: Float, y: Float) -> ShadowDecoration {
    .offset((x: x, y: y))
}
public func color(_ color: Color) -> ShadowDecoration {
    .color(color)
}
public func radius(_ radius: Float) -> ShadowDecoration {
    .radius(radius)
}

public enum DecorationProperty {
    // Background
    case color(Color)

    // Border
    case borderColor(Color)
    case borderWidth(Float)

    // Corners
    case cornerRadius(Float)

    // Shadow
    case shadow([ShadowDecoration])
}

/// Hack to avoid specify the name of the enum in the `ArrayBuilder`.
///
/// First idea that didn't work out:
///
///     .decoration {
///         .color(Color(0xFF00FF))
///     }
///
/// Second idea that work out:
///
///     .decorate {
///         color(Color(0xFF00FF))
///     }
///
public func color(_ color: Color) -> DecorationProperty { .color(color) }
public func borderColor(_ borderColor: Color) -> DecorationProperty {
    .borderColor(borderColor)
}
public func borderWidth(_ borderWidth: Float) -> DecorationProperty {
    .borderWidth(borderWidth)
}
public func cornerRadius(_ cornerRadius: Float) -> DecorationProperty {
    .cornerRadius(cornerRadius)
}
public func
shadow(@ArrayBuilder _ shadowBuilder: () -> [ShadowDecoration])
-> DecorationProperty {
    .shadow(shadowBuilder())
}

public struct DecorationBox<Content: View>: View {

    // MARK: Properties

    private let content: Content
    public let decorations: [DecorationProperty]

    // MARK: Lifecycle

    /// Creates a new decoration box used to add styles avoiding any modifications to the
    /// children.
    public init(_ decorations: [DecorationProperty] = [],
                @ViewBuilder _ contentBuilder: () -> Content) {
        content = contentBuilder()
        self.decorations = decorations
    }

    public init(decorations: [DecorationProperty] = [],
                _ content: Content) {
        self.content = content
        self.decorations = decorations
    }

    // MARK: View

    public var body: View { content }
}

extension DecorationBox where Content == Expand<Empty> {
    public init(_ decorations: [DecorationProperty] = []) {
        self.content = Expand<Empty>()
        self.decorations = decorations
    }
}

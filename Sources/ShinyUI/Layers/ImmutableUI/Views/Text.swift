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

public struct Text: View {

    // MARK: Types

    public enum Style {
        case color(Color)
        case foregroundColor(Color)
        case font(String, Float)
        case numberOfLines(UInt)
    }

    // MARK: Properties

    public var title: String
    public let styles: [Style]

    // MARK: Lifecycle

    public init(_ title: String) {
        self.title = title
        styles = []
    }

    fileprivate init(_ title: String, styles: [Style]) {
        self.title = title
        self.styles = styles
    }

    public var body: Never { fatalError() }
}

// MARK: - Styles

extension Text {
    public func foregroundColor(_ color: Color) -> Text {
        Text(title, styles: styles + [.foregroundColor(color)])
    }

    public func color(_ color: Color) -> Text {
        Text(title, styles: styles + [.color(color)])
    }

    public func font(_ fontName: String = "", _ size: Float = 17) -> Text {
        Text(title, styles: styles + [.font(fontName, size)])
    }

    public func lines(_ numberOfLines: UInt) -> Text {
        Text(title, styles: styles + [.numberOfLines(numberOfLines)])
    }
}

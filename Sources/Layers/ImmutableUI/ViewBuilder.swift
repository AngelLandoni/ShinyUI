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

// TODO: WTF
extension String: View {
    public typealias Body = Never
    public var body: View { fatalError() }
}

@_functionBuilder
public struct ViewBuilder {
    public static func
    buildBlock(_ content: View) -> View {
        content
    }

    ///
    /// {
    ///     let a: Text = Text()
    ///     let b: Text = Text()
    ///     let c: OptinalStorage = ViewBuilder.buildIf(flagToCheck ? Text() : nil)
    ///     return ViewBuilder.tuple(a,b,c)
    /// }
    ///
    public static func
    buildIf<Content: View>(_ content: Content?) -> Content? {
        content
    }

    public static func
    buildEither<TrueContent: View, FalseContent: View>(first: TrueContent)
        -> ConditionalStorage<TrueContent, FalseContent> {
        .init(.trueContent(first))
    }

    public static func
    buildEither<TrueContent: View, FalseContent: View>(second: FalseContent)
        -> ConditionalStorage<TrueContent, FalseContent> {
        .init(.falseContent(second))
    }

    static func buildDo<Content: View>(_ content: Content) -> Content { return content }
}

extension ViewBuilder {
    public static func buildBlock(_ c0: View, _ c1: View) -> Storage2 {
        Storage2(c0, c1)
    }

    public static func buildBlock(_ c0: View,
                                            _ c1: View,
                                            _ c2: View) -> Storage3 {
        Storage3(c0, c1, c2)
    }

    public static func buildBlock(_ c0: View,
                                            _ c1: View,
                                            _ c2: View,
                                            _ c3: View) -> Storage4 {
        Storage4(c0, c1, c2, c3)
    }

    public static func buildBlock(_ c0: View,
                                            _ c1: View,
                                            _ c2: View,
                                            _ c3: View,
                                            _ c4: View) -> Storage5 {
        Storage5(c0, c1, c2, c3, c4)
    }

    public static func buildBlock(_ c0: View,
                                            _ c1: View,
                                            _ c2: View,
                                            _ c3: View,
                                            _ c4: View,
                                            _ c5: View) -> Storage6 {
        Storage6(c0, c1, c2, c3, c4, c5)
    }

    public static func buildBlock(_ c0: View,
                                            _ c1: View,
                                            _ c2: View,
                                            _ c3: View,
                                            _ c4: View,
                                            _ c5: View,
                                            _ c6: View) -> Storage7 {
        Storage7(c0, c1, c2, c3, c4, c5, c6)
    }

    public static func buildBlock(_ c0: View,
                                            _ c1: View,
                                            _ c2: View,
                                            _ c3: View,
                                            _ c4: View,
                                            _ c5: View,
                                            _ c6: View,
                                            _ c7: View) -> Storage8 {
        Storage8(c0, c1, c2, c3, c4, c5, c6, c7)
    }

    public static func buildBlock(_ c0: View,
                                            _ c1: View,
                                            _ c2: View,
                                            _ c3: View,
                                            _ c4: View,
                                            _ c5: View,
                                            _ c6: View,
                                            _ c7: View,
                                            _ c8: View) -> Storage9 {
        Storage9(c0, c1, c2, c3, c4, c5, c6, c7, c8)
    }
}

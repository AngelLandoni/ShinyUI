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

extension String: View {
    public typealias Body = Never

    public var body: Never { fatalError() }
}

@_functionBuilder
public struct ViewBuilder {
    public static func
    buildBlock<Content: View>(_ content: Content) -> Content {
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
    public static func buildBlock<C0: View,
                                  C1: View>(_ c0: C0,
                                            _ c1: C1) -> Storage2<C0, C1> {
        Storage2(c0, c1)
    }

    public static func buildBlock<C0: View,
                                  C1: View,
                                  C2: View>(_ c0: C0,
                                            _ c1: C1,
                                            _ c2: C2) -> Storage3<C0, C1, C2> {
        Storage3(c0, c1, c2)
    }

    public static func buildBlock<C0: View,
                                  C1: View,
                                  C2: View,
                                  C3: View>(_ c0: C0,
                                            _ c1: C1,
                                            _ c2: C2,
                                            _ c3: C3) -> Storage4<C0,
                                                                  C1,
                                                                  C2,
                                                                  C3> {
        Storage4(c0, c1, c2, c3)
    }

    public static func buildBlock<C0: View,
                                  C1: View,
                                  C2: View,
                                  C3: View,
                                  C4: View>(_ c0: C0,
                                            _ c1: C1,
                                            _ c2: C2,
                                            _ c3: C3,
                                            _ c4: C4) -> Storage5<C0,
                                                                  C1,
                                                                  C2,
                                                                  C3,
                                                                  C4> {
        Storage5(c0, c1, c2, c3, c4)
    }

    public static func buildBlock<C0: View,
                                  C1: View,
                                  C2: View,
                                  C3: View,
                                  C4: View,
                                  C5: View>(_ c0: C0,
                                            _ c1: C1,
                                            _ c2: C2,
                                            _ c3: C3,
                                            _ c4: C4,
                                            _ c5: C5) -> Storage6<C0,
                                                                  C1,
                                                                  C2,
                                                                  C3,
                                                                  C4,
                                                                  C5> {
        Storage6(c0, c1, c2, c3, c4, c5)
    }

    public static func buildBlock<C0: View,
                                  C1: View,
                                  C2: View,
                                  C3: View,
                                  C4: View,
                                  C5: View,
                                  C6: View>(_ c0: C0,
                                            _ c1: C1,
                                            _ c2: C2,
                                            _ c3: C3,
                                            _ c4: C4,
                                            _ c5: C5,
                                            _ c6: C6) -> Storage7<C0,
                                                                  C1,
                                                                  C2,
                                                                  C3,
                                                                  C4,
                                                                  C5,
                                                                  C6> {
        Storage7(c0, c1, c2, c3, c4, c5, c6)
    }

    public static func buildBlock<C0: View,
                                  C1: View,
                                  C2: View,
                                  C3: View,
                                  C4: View,
                                  C5: View,
                                  C6: View,
                                  C7: View>(_ c0: C0,
                                            _ c1: C1,
                                            _ c2: C2,
                                            _ c3: C3,
                                            _ c4: C4,
                                            _ c5: C5,
                                            _ c6: C6,
                                            _ c7: C7) -> Storage8<C0,
                                                                  C1,
                                                                  C2,
                                                                  C3,
                                                                  C4,
                                                                  C5,
                                                                  C6,
                                                                  C7> {
        Storage8(c0, c1, c2, c3, c4, c5, c6, c7)
    }

    public static func buildBlock<C0: View,
                                  C1: View,
                                  C2: View,
                                  C3: View,
                                  C4: View,
                                  C5: View,
                                  C6: View,
                                  C7: View,
                                  C8: View>(_ c0: C0,
                                            _ c1: C1,
                                            _ c2: C2,
                                            _ c3: C3,
                                            _ c4: C4,
                                            _ c5: C5,
                                            _ c6: C6,
                                            _ c7: C7,
                                            _ c8: C8) -> Storage9<C0,
                                                                  C1,
                                                                  C2,
                                                                  C3,
                                                                  C4,
                                                                  C5,
                                                                  C6,
                                                                  C7,
                                                                  C8> {
        Storage9(c0, c1, c2, c3, c4, c5, c6, c7, c8)
    }
}

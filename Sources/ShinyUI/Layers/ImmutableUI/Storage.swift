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

public protocol TupleView: View { }

extension Optional: View where Wrapped: View {
    public var body: Never { fatalError() }
}

public struct ConditionalStorage<TrueContent: View, FalseContent: View>: View {
    public enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }

    public let storage: Storage

    public init(_ storage: Storage) {
        self.storage = storage
    }

    public var body: Never { fatalError() }
}

/// Apple uses a tuple for this, I think the reason for that is they heavy rely on Swift rutime for SwiftUI.
/// The AG is in C++ so they need a memory layout guarantee, so I think that is the reason why they
/// are wraping a tupe inside a struct (https://forums.swift.org/t/how-to-define-structures-that-can-be-passed-to-c/23901/5)
///
/// Avoiding runtime magic.
///
public struct Storage2<A: View, B: View>: TupleView {

    public let a: A
    public let b: B

    public init(_ a: A, _ b: B) {
        self.a = a
        self.b = b
    }

    public var body: Never { fatalError() }
}

public struct Storage3<A: View, B: View, C: View>: TupleView {

    public let a: A
    public let b: B
    public let c: C

    public init(_ a: A, _ b: B, _ c: C) {
        self.a = a
        self.b = b
        self.c = c
    }

    public var body: Never { fatalError() }
}

public struct Storage4<A: View, B: View, C: View, D: View>: TupleView {

    public let a: A
    public let b: B
    public let c: C
    public let d: D

    public init(_ a: A, _ b: B, _ c: C, _ d: D) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }

    public var body: Never { fatalError() }
}

public struct Storage5<A: View,
                       B: View,
                       C: View,
                       D: View,
                       E: View>: TupleView {

    public let a: A
    public let b: B
    public let c: C
    public let d: D
    public let e: E

    public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.e = e
    }

    public var body: Never { fatalError() }
}

public struct Storage6<A: View,
                       B: View,
                       C: View,
                       D: View,
                       E: View,
                       F: View>: TupleView {

    public let a: A
    public let b: B
    public let c: C
    public let d: D
    public let e: E
    public let f: F

    public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.e = e
        self.f = f
    }

    public var body: Never { fatalError() }
}

public struct Storage7<A: View,
                       B: View,
                       C: View,
                       D: View,
                       E: View,
                       F: View,
                       G: View>: TupleView {

    public let a: A
    public let b: B
    public let c: C
    public let d: D
    public let e: E
    public let f: F
    public let g: G

    public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.e = e
        self.f = f
        self.g = g
    }

    public var body: Never { fatalError() }
}

public struct Storage8<A: View,
                       B: View,
                       C: View,
                       D: View,
                       E: View,
                       F: View,
                       G: View,
                       H: View>: TupleView {

    public let a: A
    public let b: B
    public let c: C
    public let d: D
    public let e: E
    public let f: F
    public let g: G
    public let h: H

    public init(_ a: A,
                _ b: B,
                _ c: C,
                _ d: D,
                _ e: E,
                _ f: F,
                _ g: G,
                _ h: H) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.e = e
        self.f = f
        self.g = g
        self.h = h
    }

    public var body: Never { fatalError() }
}

public struct Storage9<A: View,
                       B: View,
                       C: View,
                       D: View,
                       E: View,
                       F: View,
                       G: View,
                       H: View,
                       I: View>: TupleView {

    public let a: A
    public let b: B
    public let c: C
    public let d: D
    public let e: E
    public let f: F
    public let g: G
    public let h: H
    public let i: I

    public init(_ a: A,
                _ b: B,
                _ c: C,
                _ d: D,
                _ e: E,
                _ f: F,
                _ g: G,
                _ h: H,
                _ i: I) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.e = e
        self.f = f
        self.g = g
        self.h = h
        self.i = i
    }

    public var body: Never { fatalError() }
}

public struct Storage10<A: View,
                        B: View,
                        C: View,
                        D: View,
                        E: View,
                        F: View,
                        G: View,
                        H: View,
                        I: View,
                        J: View>: TupleView {

    public let a: A
    public let b: B
    public let c: C
    public let d: D
    public let e: E
    public let f: F
    public let g: G
    public let h: H
    public let i: I
    public let j: J

    public init(_ a: A,
                _ b: B,
                _ c: C,
                _ d: D,
                _ e: E,
                _ f: F,
                _ g: G,
                _ h: H,
                _ i: I,
                _ j: J) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.e = e
        self.f = f
        self.g = g
        self.h = h
        self.i = i
        self.j = j
    }

    public var body: Never { fatalError() }
}

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
    public var body: View { fatalError() }
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

    public var body: View { fatalError() }
}

/// Apple uses a tuple for this, I think the reason for that is they heavy rely on Swift rutime for SwiftUI.
/// The AG is in C++ so they need a memory layout guarantee, so I think that is the reason why they
/// are wraping a tupe inside a struct (https://forums.swift.org/t/how-to-define-structures-that-can-be-passed-to-c/23901/5)
///
/// Avoiding runtime magic.
///
public struct Storage2: TupleView {

    public let a: View
    public let b: View

    public init(_ a: View, _ b: View) {
        self.a = a
        self.b = b
    }

    public var body: View { fatalError() }
}

public struct Storage3: TupleView {

    public let a: View
    public let b: View
    public let c: View

    public init(_ a: View, _ b: View, _ c: View) {
        self.a = a
        self.b = b
        self.c = c
    }

    public var body: View { fatalError() }
}

public struct Storage4: TupleView {

    public let a: View
    public let b: View
    public let c: View
    public let d: View

    public init(_ a: View, _ b: View, _ c: View, _ d: View) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }

    public var body: View { fatalError() }
}

public struct Storage5: TupleView {

    public let a: View
    public let b: View
    public let c: View
    public let d: View
    public let e: View

    public init(_ a: View, _ b: View, _ c: View, _ d: View, _ e: View) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.e = e
    }

    public var body: View { fatalError() }
}

public struct Storage6: TupleView {

    public let a: View
    public let b: View
    public let c: View
    public let d: View
    public let e: View
    public let f: View

    public init(_ a: View,
                _ b: View,
                _ c: View,
                _ d: View,
                _ e: View,
                _ f: View) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.e = e
        self.f = f
    }

    public var body: View { fatalError() }
}

public struct Storage7: TupleView {

    public let a: View
    public let b: View
    public let c: View
    public let d: View
    public let e: View
    public let f: View
    public let g: View

    public init(_ a: View,
                _ b: View,
                _ c: View,
                _ d: View,
                _ e: View,
                _ f: View,
                _ g: View) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.e = e
        self.f = f
        self.g = g
    }

    public var body: View { fatalError() }
}

public struct Storage8: TupleView {

    public let a: View
    public let b: View
    public let c: View
    public let d: View
    public let e: View
    public let f: View
    public let g: View
    public let h: View

    public init(_ a: View,
                _ b: View,
                _ c: View,
                _ d: View,
                _ e: View,
                _ f: View,
                _ g: View,
                _ h: View) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.e = e
        self.f = f
        self.g = g
        self.h = h
    }

    public var body: View { fatalError() }
}

public struct Storage9: TupleView {

    public let a: View
    public let b: View
    public let c: View
    public let d: View
    public let e: View
    public let f: View
    public let g: View
    public let h: View
    public let i: View

    public init(_ a: View,
                _ b: View,
                _ c: View,
                _ d: View,
                _ e: View,
                _ f: View,
                _ g: View,
                _ h: View,
                _ i: View) {
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

    public var body: View { fatalError() }
}

public struct Storage10: TupleView {

    public let a: View
    public let b: View
    public let c: View
    public let d: View
    public let e: View
    public let f: View
    public let g: View
    public let h: View
    public let i: View
    public let j: View

    public init(_ a: View,
                _ b: View,
                _ c: View,
                _ d: View,
                _ e: View,
                _ f: View,
                _ g: View,
                _ h: View,
                _ i: View,
                _ j: View) {
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

    public var body: View { fatalError() }
}

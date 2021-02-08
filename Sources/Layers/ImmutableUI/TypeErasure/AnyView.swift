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

protocol AnyViewBase {
    func didLoad()
    func didMount()
    func didUnmount()
    func didRender()
}

struct AnyViewStorage<V: View>: AnyViewBase {
    let _view: V

    init(_ view: V) {
        _view = view
    }

    func didLoad() {
        _view.didLoad()
    }

    func didMount() {
        _view.didMount()
    }

    func didUnmount() {
        _view.didUnmount()
    }

    func didRender() {
        _view.didRender()
    }
}

struct AnyView: View {
    let storage: AnyViewBase
    let builder: (World) -> Element

    init<V: View>(_ view: V) {
        storage = AnyViewStorage(view)
        builder = { world in
            buildElementTree(view, world)
        }
    }
    
    public var body: View { fatalError() }

    func build(_ world: World) -> Element {
        builder(world)
    }

    func didLoad() {
        storage.didLoad()
    }

    func didMount() {
        storage.didMount()
    }

    func didUnmount() {
        storage.didUnmount()
    }

    func didRender() {
        storage.didRender()
    }
}

extension View {
    var asAny: AnyView { AnyView(self) }
}

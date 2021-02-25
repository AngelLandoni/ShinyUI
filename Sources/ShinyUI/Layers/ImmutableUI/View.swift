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

// MARK: - View

public protocol View {
    associatedtype Body: View
    var body: Body { get }

    /// Should be called when the `View`'s` `Element` is created and submitted to the `World`
    ///
    /// - Note: Check if is better have a separated protocol for this.
    ///         I do not like how SwiftUI handles the on appear and the rest of state callbacks.
    func didLoad()

    func didMount()
    func didUnmount()
    func didRender()
}

// MARK: Default

extension View {
    public func didLoad() { }
    public func didMount() { }
    public func didUnmount() { }
    public func didRender() { }
}

// MARK: Modifiers

extension View {

    // MARK: Sizing

    public func frame(width: Float? = nil, height: Float? = nil) -> some View {
        FrameModifier(width: width, height: height, self)
    }

    public func fractionallyFrame(width: Float32? = nil,
                                  height: Float32? = nil) -> some View {
        FractionallyFrameModifier(width: width, height: height, self)
    }

    // MARK: Style

    public func clip() -> some View {
        ClipperModifier(self)
    }

    public func margin(_ edge: Edge<Float>) -> some View {
        MarginModifier([edge], self)
    }

    public func margin(_ edges: [Edge<Float>]) -> some View {
        MarginModifier(edges, self)
    }

    public func
    margin(@ArrayBuilder _ edgesBuilder: () -> [Edge<Float>]) -> some View {
        MarginModifier(edgesBuilder(), self)
    }

    public func decorate(_ decorations: [DecorationProperty]) -> some View {
        DecorationBox(decorations: decorations, self)
    }

    public func
    decorate(@ArrayBuilder _ builder: () -> [DecorationProperty]) -> some View {
        DecorationBox(decorations: builder(), self)
    }

    public func center(_ direction: Direction = .all) -> some View {
        CenterModifier(direction: direction, self)
    }

    // MARK: TabBarItem

    public func
    tabBarItem<Content: View>(
        @ViewBuilder _ contentBuilder: () -> Content) -> some View {
        TabBarItemModifier(contentBuilder(), content: self)
    }
    
    // MARK: Events
    
    public func onTap(_ action: @escaping () -> Void) -> some View {
        TapGestureModifier(action, content: self)
    }

    // MARK: Utils

    public func rasterize() -> some View {
        RasterizeModifier(self)
    }
}

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

typealias ElementBuilderBlock = () -> Element
typealias NavigationCallbackBlock = (ElementBuilderBlock,
                                     [EnviromentProperty]) -> Void

public struct NavigationContext {
    
    var storable: AnyStorable
    var parent: Element?
    
    /// Contains a list of `EnviromentProperty` availables in the branch.
    ///
    /// This is needed due the nature of the `EnviromentProperty` extraction algorithm, when the
    /// `View` is created the stack was already cleared so the new `Element` child does not have
    /// a way to access them.
    ///
    var currentEnviromentProps: [EnviromentProperty]
    
    var pushCallback: Box<NavigationCallbackBlock?> = Box(nil)
    var popCallBack: Box<(() -> Void)?> = Box(nil)
    
    /// Push a new `View` into the associated `Navigation`.
    ///
    /// - Parameter view: The new `View` to be pushed.
    public func push<V: View>(_ view: V) {
        pushCallback.content?(
            {
                guard let parent = parent else {
                    fatalError("The child can not be linked to any parent")
                }
                // Propagate enviroment properties.
                let _ = addEnviroment(properties: currentEnviromentProps,
                                      in: storable)
                defer {
                    removeEnviroment(properties: currentEnviromentProps,
                                     from: storable)
                }
                /// The view Element is generated inside the block to erase the view and avoid the
                /// AnyView and the build problems related with it.
                return ShinyUI.buildElementTree(view,
                                                linkedTo: parent,
                                                storable: storable,
                                                replaceChild: false)
            },
            extractEnviromentProperties(in: view)
        )
    }
    
    /// Pops the current visible view for the associated `Navigation`.
    public func pop() {
        popCallBack.content?()
    }
}

public struct Navigation<Content: View>: View {

    private let content: Content

    public init(@ViewBuilder _ contentBuilder : () -> Content) {
        self.content = contentBuilder()
    }

    public var body : some View { content }
}

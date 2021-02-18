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

import Runtime

#if canImport(UIKit)

import UIKit

// TEMP
final class TheMainLayer: UIView, DisplayElement {
    
    func updateFrame(_ frame: ElementFrame) {
        self.frame = frame.asFrame
    }

    func submit(_ displayElement: DisplayElement) {
        isUserInteractionEnabled = true
        addSubview(displayElement.getView())
    }

    func remove() {

    }

    func getView() -> UIView {
        return self
    }
}

/// An entrypoint to mach UIKit with ShinyUI.
///
/// - Note: Each view controller contains their own states and components that are not exchangeable for
///         the moment (May Be considered `Universe`)
public final class HostController<V: View>: UIViewController {

    // MARK: Properties

    /// Contains a `World`
    /// - Note: This variable handles all the states inside the host, do not modify this outside the class
    ///         itself.
    private let world: World = World()

    /// Contains the root view used to trigger the rest of processes.
    private let rootView: V

    private let runLoop: MainRunLoopHook = MainRunLoopHook()

    // TEMP:
    let temp: TheMainLayer = TheMainLayer()

    // MARK: Lifecycle

    public init(_ rootView: V) {
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
        wakeUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    // MARK: Private methods

    private func wakeUp() {
        view.addSubview(temp)
        view.backgroundColor = .white

        createElements()

        // Trigger the maintain loop.
        runLoop.action = { [unowned world] in
            mantain(world: world)
        }
    }

    private func createElements() {
        // Set the initial size screen.
        world.updateScreenSize(view.frame.size.asSize)

        // TODO: Move this to a background thread.
        // Generate the rootView using the local `World`.
        generate(rootView: rootView, in: world)
        guard let rootElement = world.rootElement else {
            fatalError(ErrorMessages.emptyRoot)
        }
        layout(element: rootElement.elementID, in: world)
        render(in: temp, using: world)
    }


    // MARK: - Window handling

    public typealias Coordinator = UIViewControllerTransitionCoordinator

    public override func viewWillTransition(to size: CGSize,
                                            with coordinator: Coordinator) {
        world.updateScreenSize(size.asSize)
        guard let rootElement = world.rootElement else {
            fatalError(ErrorMessages.emptyRoot)
        }
        layout(element: rootElement.elementID, in: world)
        world.syncLayoutAndDisplay()
    }
}

#endif

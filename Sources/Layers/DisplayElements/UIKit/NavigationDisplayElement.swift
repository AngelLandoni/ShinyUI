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

#if canImport(UIKit)
import UIKit

final class NavigationDisplayElement: DisplayElement {

    let navigationController = UINavigationController()
    weak var rootController: UIViewController?
    
    func configure() {
        let root = UIViewController()
        navigationController.setViewControllers([root],
                                                animated: false)
        rootController = root
    }
    
    func updateFrame(_ frame: ElementFrame) {
        navigationController.view.frame = frame.asFrame
    }
    
    func submit(_ displayElement: DisplayElement) {
        rootController?.view.addSubview(displayElement.getView())
    }
    
    func remove() {
        navigationController.view.removeFromSuperview()
    }
    
    func getView() -> UIView {
        navigationController.view
    }
}

extension NavigationElement: TreeDisplayElementBuilder {
    func buildDisplayElementTree<S: Storable>(_ storable: S, _ host: DisplayElement) {
        let navigation = createDisplayElement(type: NavigationDisplayElement.self,
                                              for: self,
                                              in: storable)
        host.submit(navigation)
        navigation.configure()
        
        let child = getChildElementId(for: elementID, in: storable)
        ShinyUI.buildDisplayElementTree(child, storable, navigation)
    }
}

#endif

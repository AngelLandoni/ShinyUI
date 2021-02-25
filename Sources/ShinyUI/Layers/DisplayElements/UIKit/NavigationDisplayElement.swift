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
    
    var elements: [ElementID] = []
    var properties: [[EnviromentProperty]] = [[]]
    
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

extension UINavigationController {
    func popViewController(animated: Bool, completion: @escaping () -> ()) {
        popViewController(animated: animated)
        
        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}

extension NavigationElement: TreeDisplayElementBuilder {
    func buildDisplayElementTree<S: Storable>(_ storable: S,
                                              _ host: DisplayElement) {
        let navigation = createDisplayElement(
            type: NavigationDisplayElement.self,
            for: self,
            in: storable
        )
        
        host.submit(navigation)
        navigation.configure()
        
        context?.pushCallback.content = {
            [weak navigation, weak storable] viewBuilder, props in
            guard let storable = storable else { return }
            
            let element: Element = viewBuilder()
            let container = ContainerDisplayElement()
            // Force the layout of the element.
            ShinyUI.layout(element: element.elementID, in: storable)
            // Create the views.
            ShinyUI.buildDisplayElementTree(element, storable, container)
            
            // Add to the storable all the new enviroment variables if the enviroment
            // variable already exist update it.
            let added = addEnviroment(properties: props, in: storable)
            
            navigation?.properties.append(added)
            navigation?.elements.append(element.elementID)

            // Create a simple host controller to send the view.
            let newViewController = UIViewController()
            newViewController.view.frame = navigation?.getView().frame ?? .zero
            newViewController.view = container
            
            navigation?.navigationController.pushViewController(
                newViewController,
                animated: true
            )
        }
        
        context?.popCallBack.content = { [weak navigation, weak storable] in
            navigation?.navigationController.popViewController(animated: true, completion: {
                guard let storable = storable else { return }
            
                guard let lastElement = navigation?.elements.popLast() else { return }
                guard let lastProps = navigation?.properties.popLast() else { return }
                
                removeElementTree(element: lastElement, in: storable)
                removeEnviroment(properties: lastProps, from: storable)
                
                storable.doubleUnlink(child: lastElement, from: self.elementID)
            })
        }
        
        let child = getChildElementId(for: elementID, in: storable)
        ShinyUI.buildDisplayElementTree(child, storable, navigation)
    }
}

#endif

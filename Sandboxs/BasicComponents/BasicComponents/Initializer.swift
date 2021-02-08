//
//  Initializer.swift
//  BasicComponents
//
//  Created by Angel Landoni on 28/12/20.
//

import UIKit
import ShinyUI

enum Initializer {

    static func initApplication(scene: UIWindowScene) -> UIWindow {
        let window = UIWindow(frame: scene.coordinateSpace.bounds)
        window.windowScene = scene
        window.rootViewController = HostController(App())
        window.makeKeyAndVisible()
        return window
    }
}

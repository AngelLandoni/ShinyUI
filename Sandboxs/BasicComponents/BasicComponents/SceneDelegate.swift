//
//  SceneDelegate.swift
//  BasicComponents
//
//  Created by Angel Landoni on 28/12/20.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        guard let scene = (scene as? UIWindowScene) else { return }
        window = Initializer.initApplication(scene: scene)

        #if targetEnvironment(macCatalyst)
        if let titlebar = scene.titlebar {
            titlebar.titleVisibility = .hidden
            titlebar.toolbar = nil
        }
        scene.sizeRestrictions?.minimumSize = CGSize(width: 600, height: 300)
        #endif
    }
}

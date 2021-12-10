//
//  SceneDelegate.swift
//  TechTestApp
//
//  Created by Artur Dąbkowski on 08/12/2021.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var applicationCoordinator: ApplicationCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            fatalError("Unable to cast UIScene to UIWindowScene")
        }

        let window = UIWindow(windowScene: windowScene)

        applicationCoordinator = ApplicationCoordinator(window: window, environment: Environment())
        applicationCoordinator?.start()

        self.window = window
    }
}

extension SceneDelegate {
    func injectProperties(_ window: UIWindow) {
        self.window = window
    }
}

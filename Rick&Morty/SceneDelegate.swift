//
//  SceneDelegate.swift
//  Rick&Morty
//
//  Created by Artur Peplinski on 05/07/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private var appCoordinator: AppCoordinator?

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(rootViewController: navigationController)
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        appCoordinator?.start()
    }
}

//
//  SceneDelegate.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 11/11/2021.
//

import UIKit
import NetFox
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        FirebaseApp.configure()
#if DEBUG
        NFX.sharedInstance().start()
#endif

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene

        let navigationController = UINavigationController()

        window?.rootViewController = navigationController

        let navigator = DefaultOnBoardingNavigator(navigationController: navigationController, window: window)
        let scenario = OnBoardingScenario(navigator: navigator)
        scenario.begin()

    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let universalLinkUrl = userActivity.webpageURL else { return }
        if universalLinkUrl.path == "/admin/reset-password" {

            guard let url = URLComponents(string: universalLinkUrl.absoluteString),
                  let tokenQueryItem = url.queryItems?.first(where: { $0.name == "token" }),
                  let token = tokenQueryItem.value else { return }

            let navigator = DefaultAuthenticationNavigator(window: window)
            window?.makeKeyAndVisible()
            window?.rootViewController = navigator.navigationController
            let scenario = AuthenticationScenario(navigator: navigator)
            scenario.begin(from: .resetPassword(token: token))
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
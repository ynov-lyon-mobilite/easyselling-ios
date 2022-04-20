//
//  SceneDelegate.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 11/11/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var navigationController: UINavigationController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene

        let navigator = DefaultLaunchScreenNavigator(window: window)
        let scenario = LaunchScreenScenario(navigator: navigator)

        scenario.begin { [weak self] in
            guard let userActivity = connectionOptions.userActivities.first,
                          userActivity.activityType == NSUserActivityTypeBrowsingWeb,
                          let universalLinkUrl = userActivity.webpageURL else {

                self?.startStartupScenario()
                return
            }

            switch universalLinkUrl.path {
            case "/admin/reset-password": self?.resetPassword(according: universalLinkUrl)
            case "vehicles/share": self?.shareVehicleInfos(according: universalLinkUrl)
            default: self?.startStartupScenario()
            }
        }
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let universalLinkUrl = userActivity.webpageURL else { return }

        switch universalLinkUrl.path {
        case "/admin/reset-password": resetPassword(according: universalLinkUrl)
        case "vehicles/share": shareVehicleInfos(according: universalLinkUrl)
        default: break
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

    private func resetPassword(according universalLinkUrl: URL) {
        guard let url = URLComponents(string: universalLinkUrl.absoluteString),
              let token = url.queryItems?.first(where: { $0.name == "oobCode" })?.value else { return }

        setupNavigationController()
        startAuthenticationScenario(withToken: token, according: .resetPassword(token: token))
    }

    private func shareVehicleInfos(according universalLinkUrl: URL) {
        guard let url = URLComponents(string: universalLinkUrl.absoluteString),
              let idQueryItem = url.queryItems?.first(where: { $0.name == "id" }),
              let id = idQueryItem.value else { return }

        setupNavigationController()
        startStartupScenario(accordingBeginning: .vehicleInfoShare(id: id))
    }

    private func startStartupScenario(accordingBeginning beginWay: StartupScenario.BeginWay = .usual) {
        let navigator = DefaultStartupNavigator(window: window)
        let scenario = StartupScenario(navigator: navigator)
        Task {
            await scenario.begin(from: beginWay)
        }
    }

    private func startAuthenticationScenario(withToken token: String, according beginType: AuthenticationScenario.BeginType) {
        guard let navigationController = navigationController else {
            return
        }
        let navigator = DefaultAuthenticationNavigator(window: window, navigationController: navigationController)
        let scenario = AuthenticationScenario(navigator: navigator)
        scenario.begin(from: beginType)
    }

    private func setupNavigationController() {
        navigationController = UINavigationController()
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
    }
}

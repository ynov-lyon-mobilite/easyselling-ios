//
//  AppDelegate.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let navigationController = UINavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let onBoardingNavigator: OnBoardingNavigator = DefaultOnBoardingNavigator(navigationController: navigationController)
        let onBoardingScenario: OnBoardingScenario = OnBoardingScenario(navigator: onBoardingNavigator)
        onBoardingScenario.begin()
        
        return true
    }
}

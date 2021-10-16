//
//  AppDelegate.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation
import UIKit
import NetFox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        #if DEBUG
            NFX.sharedInstance().start()
        #endif
        
        let navigationController = UINavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let navigator = DefaultAccountCreationNavigator(navigationController: navigationController)
        let scenario = AccountCreationScenario(navigator: navigator)
        scenario.begin {}
        
        return true
    }
}
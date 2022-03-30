//
//  AppDelegate.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import UIKit
import CoreData
import Firebase
import netfox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
#if DEBUG
        NFX.sharedInstance().start()
#endif

        return true
    }
}

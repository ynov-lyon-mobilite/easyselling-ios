//
//  LaunchScreenScenario.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 20/04/2022.
//

import Foundation
import UIKit
import SwiftUI

class LaunchScreenScenario {
    private let navigator: LaunchScreenNavigator

    init(navigator: LaunchScreenNavigator) {
        self.navigator = navigator
    }

    func begin(onFinish: @escaping Action) {
        navigator.navigatesToLaunchScreen(onFinish: onFinish)
    }
}

protocol LaunchScreenNavigator {
    func navigatesToLaunchScreen(onFinish: @escaping Action)
}

class DefaultLaunchScreenNavigator: LaunchScreenNavigator {

    init(window: UIWindow?) {
        self.window = window
    }

    private var window: UIWindow?
    private var navigationController: UINavigationController = UINavigationController()

    func navigatesToLaunchScreen(onFinish: @escaping Action) {
        window?.rootViewController = navigationController
        let view = LaunchScreenView(onFinish: onFinish)
        navigationController.pushViewController(UIHostingController(rootView: view), animated: true)
    }
}

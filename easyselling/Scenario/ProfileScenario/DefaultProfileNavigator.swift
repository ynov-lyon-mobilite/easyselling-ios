//
//  DefaultProfileNavigator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 26/11/2021.
//

import Foundation
import UIKit
import SwiftUI

protocol ProfileNavigator {
    func navigatesToProfile(onLogout: @escaping Action)
    func navigatesBackToAuthentication()
}

class DefaultProfileNavigator: ProfileNavigator {

    init(navigationController: UINavigationController, window: UIWindow?) {
        self.navigationController = navigationController
        self.window = window
    }

    private var navigationController: UINavigationController
    private var window: UIWindow?

    func navigatesToProfile(onLogout: @escaping Action) {
        let viewModel = ProfileViewModel(onLogout: onLogout)
        let view = ProfileView(viewModel: viewModel)
        navigationController.pushViewController(UIHostingController(rootView: view), animated: true)
    }

    func navigatesBackToAuthentication() {
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        let navigator = DefaultAuthenticationNavigator(navigationController: navigationController, window: window)
        let scenario = AuthenticationScenario(navigator: navigator)
        scenario.begin(from: .default)
    }
}

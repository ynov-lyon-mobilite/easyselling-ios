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
    func navigatesToProfile(onLogout: @escaping Action, onNavigateToSettingsMenu: @escaping Action)
    func navigatesToSettingsMenu()
}

class DefaultProfileNavigator: ProfileNavigator {

    init(navigationController: UINavigationController, window: UIWindow?) {
        self.navigationController = navigationController
        self.window = window
    }

    private var navigationController: UINavigationController
    private var window: UIWindow?

    func navigatesToProfile(onLogout: @escaping Action, onNavigateToSettingsMenu: @escaping Action) {
        let viewModel = ProfileViewModel(onLogout: onLogout, isNavigatingToSettingsMenu: onNavigateToSettingsMenu)
        let view = ProfileView(viewModel: viewModel)
        navigationController.pushViewController(UIHostingController(rootView: view), animated: true)
    }

    func navigatesToSettingsMenu() {
        let navigator = DefaultSettingsNavigator(navigationController: navigationController)
        let scenario = SettingsScenario(navigator: navigator)
        scenario.begin()
    }
}

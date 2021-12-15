//
//  DefaultSettingsNavigator.swift
//  easyselling
//
//  Created by Lucas Barthélémy on 15/12/2021.
//

import Foundation
import SwiftUI

protocol SettingsNavigator {
    func navigatesToSettingsView()
}

class DefaultSettingsNavigator: SettingsNavigator {

    init(navigationController: UINavigationController, window: UIWindow?) {
        self.navigationController = navigationController
        self.window = window
    }

    private var navigationController: UINavigationController
    private var window: UIWindow?

    func navigatesToSettingsView() {
        let viewModel = SettingsViewModel()
        let settingsView = SettingsView(viewModel: viewModel)
        let view: UIViewController = UIHostingController(rootView: settingsView)
        navigationController.pushViewController(view, animated: true)
    }
}

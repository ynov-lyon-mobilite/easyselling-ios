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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    private var navigationController: UINavigationController

    func navigatesToSettingsView() {
        let viewModel = SettingsViewModel()
        let settingsView = SettingsView(viewModel: viewModel)
        let view: UIViewController = UIHostingController(rootView: settingsView)
        navigationController.pushViewController(view, animated: true)
    }
}

//
//  HomeScenario.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 09/03/2022.
//

import Foundation
import UIKit
import SwiftUI

class HomeScenario {

    init(navigator: HomeNavigator) {
        self.navigator = navigator
    }

    private var navigator: HomeNavigator

    func begin() {
        navigator.navigatesToVehicles()
    }
}

protocol HomeNavigator {
    func navigatesToVehicles()
}

class DefaultHomeNavigator: HomeNavigator {

    init(window: UIWindow?) {
        self.window = window
    }

    private var window: UIWindow?
    private var navigationController: UINavigationController = UINavigationController()

    func navigatesToVehicles() {
        window?.rootViewController = navigationController
        navigationController.pushViewController(UIHostingController(rootView: HomeView(viewModel: HomeViewModel())), animated: true)
    }
}

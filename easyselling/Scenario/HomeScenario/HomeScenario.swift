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
        navigator.navigatesToVehicles(onLogout: goingBackToAuthenticationScenario)
    }

    func goingBackToAuthenticationScenario() {
        navigator.goingBackToAuthenticationScenario()
    }
}

protocol HomeNavigator {
    func navigatesToVehicles(onLogout: @escaping Action)
    func goingBackToAuthenticationScenario()
}

class DefaultHomeNavigator: HomeNavigator {

    init(window: UIWindow?) {
        self.window = window
    }

    private var window: UIWindow?
    private var navigationController: UINavigationController = UINavigationController()

    func navigatesToVehicles(onLogout: @escaping Action) {
        window?.rootViewController = navigationController
        navigationController.pushViewController(UIHostingController(rootView: HomeView(viewModel: HomeViewModel(onLogout: onLogout))), animated: true)
    }

    func goingBackToAuthenticationScenario() {
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        let navigator = DefaultAuthenticationNavigator(navigationController: navigationController, window: window)
        let scenario = AuthenticationScenario(navigator: navigator)
        scenario.begin(from: .default)
    }
}

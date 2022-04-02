//
//  StartupNavigator.swift
//  easyselling
//
//  Created by Théo Tanchoux on 24/11/2021.
//

import Foundation
import UIKit

protocol StartupNavigator {
    func navigatesToOnBoarding()
    func navigatesToLogin()
    func navigatesToHomeView()
}

class DefaultStartupNavigator : StartupNavigator {
    private var navigationController = UINavigationController()
    private var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
        self.window?.rootViewController = navigationController
    }

    func navigatesToOnBoarding() {
        let navigator = DefaultOnBoardingNavigator(navigationController: navigationController)
        let scenario = OnBoardingScenario(navigator: navigator)
        navigatesToLogin()
        scenario.begin()
    }

    func navigatesToLogin() {
        let navigator = DefaultAuthenticationNavigator(navigationController: navigationController, window: window)
        let scenario = AuthenticationScenario(navigator: navigator)
        scenario.begin(from: .default)
    }

    func navigatesToHomeView() {
        let navigator = DefaultHomeNavigator(window: window)
        let scenario = HomeScenario(navigator: navigator)

        scenario.begin()
    }
}

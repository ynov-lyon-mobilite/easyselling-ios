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

    init(navigationController: UINavigationController, window: UIWindow?) {
        self.navigationController = navigationController
        self.window = window
    }

    private var navigationController: UINavigationController
    private var window: UIWindow?

    func navigatesToOnBoarding() {
        let navigator = DefaultOnBoardingNavigator(navigationController: navigationController, window: window)
        let scenario = OnBoardingScenario(navigator: navigator)
        scenario.begin()
    }

    func navigatesToLogin() {
        let navigator = DefaultAuthenticationNavigator(window: window)
        let scenario = AuthenticationScenario(navigator: navigator)
        scenario.begin(from: .default)
    }

    func navigatesToHomeView() {
        let navigator = DefaultVehicleNavigator(navigationController: navigationController)
        let scenario = VehicleScenario(navigator: navigator)
        scenario.begin()
    }

}

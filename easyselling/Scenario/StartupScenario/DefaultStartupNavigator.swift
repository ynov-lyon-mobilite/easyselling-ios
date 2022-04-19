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
    func navigatesToHomeView(withActivationId id: String?)
}

class DefaultStartupNavigator: StartupNavigator {

    private var navigationController = UINavigationController()
    private var window: UIWindow?

    init(window: UIWindow?,
         vehicleActivator: VehicleActivator = DefaultVehicleActivator()) {
        self.window = window
        self.vehicleActivator = vehicleActivator
        self.window?.rootViewController = navigationController
    }

    private var vehicleActivator: VehicleActivator

    func navigatesToOnBoarding() {
        let navigator = DefaultOnBoardingNavigator(navigationController: navigationController)
        let scenario = OnBoardingScenario(navigator: navigator)
        navigatesToLogin()
        scenario.begin()
    }

    func navigatesToLogin() {
        let navigator = DefaultAuthenticationNavigator(window: window, navigationController: navigationController)
        let scenario = AuthenticationScenario(navigator: navigator)
        scenario.begin(from: .default)
    }

    func navigatesToHomeView(withActivationId id: String?) {
        let navigator = DefaultHomeNavigator(window: window)
        let scenario = HomeScenario(navigator: navigator)
        Task {
            guard let id = id else {
                return
            }
            try? await vehicleActivator.activateVehicle(id: id)
        }
        scenario.begin()
    }

    func navigatesToHomeView() {
        let navigator = DefaultHomeNavigator(window: window)
        let scenario = HomeScenario(navigator: navigator)

        scenario.begin()
    }
}

//
//  DefaultAuthenticationNavigator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/11/2021.
//

import Foundation
import UIKit
import SwiftUI

protocol AuthenticationNavigator {
    func navigatesToLoginPage(onAccountCreation: @escaping Action, onPasswordReset: @escaping Action, onUserLogged: @escaping Action)
    func navigatesToAccountCreation(onFinish: @escaping Action)
    func navigatesToPasswordResetRequest()
    func navigatesToPasswordReset(withToken token: String, onPasswordReset: @escaping Action)
    func goingBackToHomeView()
    func navigatesToVehicles(withVehicleActivationId id: String?)
}

class DefaultAuthenticationNavigator: AuthenticationNavigator {

    init(window: UIWindow?,
         navigationController: UINavigationController,
         vehicleActivator: VehicleActivator = DefaultVehicleActivator()) {
        self.window = window
        self.vehicleActivator = vehicleActivator
        self.navigationController = navigationController
    }

    private var window: UIWindow?
    private let navigationController: UINavigationController
    private var vehicleActivator: VehicleActivator

    func navigatesToLoginPage(onAccountCreation: @escaping Action, onPasswordReset: @escaping Action, onUserLogged: @escaping Action) {
        let viewModel = UserAuthenticationViewModel(navigateToAccountCreation: onAccountCreation, navigateToPasswordReset: onPasswordReset, onUserLogged: onUserLogged)
        let userAuthenticationView = UserAuthenticationView(viewModel: viewModel)
        navigationController.pushViewController(UIHostingController(rootView: userAuthenticationView), animated: true)
    }

    func navigatesToAccountCreation(onFinish: @escaping Action) {
        let accountCreationViewModel = AccountCreationViewModel(preparator: DefaultCredentialsPreparator(), onAccountCreated: onFinish)
        let accountCreationView = AccountCreationView(viewModel: accountCreationViewModel)
        navigationController.pushViewController(UIHostingController(rootView: accountCreationView), animated: true)
    }

    func navigatesToPasswordResetRequest() {
        let passwordResetRequestViewModel = PasswordResetRequestViewModel()
        let passwordResetRequestView = PasswordResetRequestView(viewModel: passwordResetRequestViewModel)

        navigationController.pushViewController(UIHostingController(rootView: passwordResetRequestView), animated: true)
    }

    func navigatesToPasswordReset(withToken token: String, onPasswordReset: @escaping Action) {
        let passwordResetViewModel = PasswordResetViewModel(token: token, onPasswordReset: onPasswordReset)
        let passwordResetView = PasswordResetView(viewModel: passwordResetViewModel)

        navigationController.pushViewController(UIHostingController(rootView: passwordResetView), animated: true)
    }

    func goingBackToHomeView() {
        DispatchQueue.main.async {
            self.navigationController.popViewController(animated: true)
        }
    }

    func navigatesToVehicles() {
        let navigator = DefaultHomeNavigator(window: window)
        let scenario = HomeScenario(navigator: navigator)

        scenario.begin()
	}
    func navigatesToVehicles(withVehicleActivationId id: String?) {
        let vehicleNavigator = DefaultVehicleNavigator(window: window)
        let vehicleScenario = VehicleScenario(navigator: vehicleNavigator)
        Task {
            if id != nil {
                try? await vehicleActivator.activateVehicle(id: id!)
            }
        }
        vehicleScenario.begin(withVehicleActivationId: id)
    }
}

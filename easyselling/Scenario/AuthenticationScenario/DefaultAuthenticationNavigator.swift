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
    func begin(onAccountCreation: @escaping Action, onPasswordReset: @escaping Action, onUserLogged: @escaping Action)
    func navigatesToAccountCreation(onFinish: @escaping Action)
    func navigatesToPasswordResetRequest()
    func navigatesToPasswordReset(withToken token: String, onPasswordReset: @escaping Action)
    func goingBackToHomeView()
    func navigatesToVehicles()
}

class DefaultAuthenticationNavigator: AuthenticationNavigator {

    init(window: UIWindow?) {
        self.window = window
    }

    private var window: UIWindow?
    var navigationController = UINavigationController()

    func begin(onAccountCreation: @escaping Action, onPasswordReset: @escaping Action, onUserLogged: @escaping Action) {
        window?.rootViewController = navigationController

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
        window?.rootViewController = navigationController

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
        let vehicleNavigator = DefaultVehicleNavigator(navigationController: navigationController)
        let vehicleScenario = VehicleScenario(navigator: vehicleNavigator)
        vehicleScenario.begin()
    }
}

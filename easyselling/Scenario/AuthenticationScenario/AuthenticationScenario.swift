//
//  AuthenticationScenario.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation
import UIKit
import SwiftUI

class AuthenticationScenario {
    private var navigator: AuthenticationNavigator
    
    init(navigator: AuthenticationNavigator) {
        self.navigator = navigator
    }
    
    func begin() {
        navigator.begin(onAccountCreation: self.navigatesToAccountCreation,
                        onPasswordReset: self.navigatesToPasswordReset, onUserLogged: { self.navigatesToVehicles() })
    }
    
    func navigatesToAccountCreation() {
        navigator.navigatesToAccountCreation(onFinish: self.goingBackToHomeView)
    }
    
    func navigatesToPasswordReset() {
        navigator.navigatesToPasswordReset()
    }
    
    func navigatesToVehicles() {
        navigator.navigatesToVehicles()
    }
    
    private func goingBackToHomeView() {
        navigator.goingBackToHomeView()
    }
}

protocol AuthenticationNavigator {
    func begin(onAccountCreation: @escaping Action, onPasswordReset: @escaping Action, onUserLogged: @escaping Action)
    func navigatesToAccountCreation(onFinish: @escaping Action)
    func navigatesToPasswordReset()
    func goingBackToHomeView()
    func navigatesToVehicles()
}

class DefaultAuthenticationNavigator: AuthenticationNavigator {
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    private var window: UIWindow?
    private var navigationController = UINavigationController()
    
    func begin(onAccountCreation: @escaping Action, onPasswordReset: @escaping Action, onUserLogged: @escaping Action) {
        window?.rootViewController = navigationController
        
        let viewModel = UserAuthenticationViewModel(navigateToAccountCreation: onAccountCreation, navigateToPasswordReset: onPasswordReset, onUserLogged: onUserLogged)
        let userAuthenticationView = UserAuthenticationView(viewModel: viewModel)
        navigationController.pushViewController(UIHostingController(rootView: userAuthenticationView), animated: true)
    }

    func navigatesToAccountCreation(onFinish: @escaping Action) {
        let accountCreationViewModel = AccountCreationViewModel(verificator: DefaultCredentialsVerificator(), onAccountCreated: onFinish)
        let accountCreationView = AccountCreationView(viewModel: accountCreationViewModel)
        navigationController.pushViewController(UIHostingController(rootView: accountCreationView), animated: true)
    }
    
    func navigatesToPasswordReset() {
        let passwordResetViewModel = PasswordResetViewModel()
        let passwordResetView = PasswordResetView(viewModel: passwordResetViewModel)
        
        navigationController.pushViewController(UIHostingController(rootView: passwordResetView), animated: true)
    }
    
    func goingBackToHomeView() {
        navigationController.dismiss(animated: true)
    }
    
    func navigatesToVehicles() {
        let vehicleNavigator = DefaultVehicleNavigator(navigationController: navigationController)
        let vehicleScenario = VehicleScenario(navigator: vehicleNavigator)
        vehicleScenario.begin()
    }
}

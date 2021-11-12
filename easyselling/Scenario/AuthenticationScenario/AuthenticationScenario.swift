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
    
    enum BeginType {
        case `default`
        case resetPassword(token: String)
    }
    
    private var navigator: AuthenticationNavigator
    
    init(navigator: AuthenticationNavigator) {
        self.navigator = navigator
    }
    
    func begin(from beginType: BeginType) {
        switch beginType {
        case .`default`: navigator.begin(onAccountCreation: self.navigatesToAccountCreation,
                                    onPasswordReset: self.navigatesToPasswordResetRequest, onUserLogged: { self.navigatesToVehicles() })
        case let .resetPassword(token): navigatesToPasswordReset(withToken: token)
        }
        
    }
    
    func navigatesToAccountCreation() {
        navigator.navigatesToAccountCreation(onFinish: self.goingBackToHomeView)
    }
    
    func navigatesToPasswordResetRequest() {
        navigator.navigatesToPasswordResetRequest()
    }
    
    func navigatesToPasswordReset(withToken token: String) {
        navigator.navigatesToPasswordReset(withToken: token, onPasswordReset: goingBackToHomeView)
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
        navigationController.dismiss(animated: true)
    }
    
    func navigatesToVehicles() {
        let vehicleNavigator = DefaultVehicleNavigator(navigationController: navigationController)
        let vehicleScenario = VehicleScenario(navigator: vehicleNavigator)
        vehicleScenario.begin()
    }
}

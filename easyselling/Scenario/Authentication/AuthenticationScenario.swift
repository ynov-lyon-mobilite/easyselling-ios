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
        navigator.begin(onVehicleCreationOpen: { self.navigatesToAccountCreation() })
    }
    
    func navigatesToAccountCreation() {
        navigator.navigatesToAccountCreation(onFinish: { self.goingBackToHomeView() })
    }
    
    private func goingBackToHomeView() {
        navigator.goingBackToHomeView()
    }
}

protocol AuthenticationNavigator {
    func begin(onVehicleCreationOpen: @escaping Action)
    func navigatesToAccountCreation(onFinish: @escaping Action)
    func goingBackToHomeView()
}

class DefaultAuthenticationNavigator: AuthenticationNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func begin(onVehicleCreationOpen: @escaping Action) {
        let viewModel = UserAuthenticationViewModel(navigateToAccountCreation: { onVehicleCreationOpen() })
        let userAuthenticationView = UserAuthenticationView(viewModel: viewModel)
        navigationController.pushViewController(UIHostingController(rootView: userAuthenticationView), animated: true)
    }

    func navigatesToAccountCreation(onFinish: @escaping Action) {
        let accountCreationViewModel = AccountCreationViewModel(verificator: DefaultInformationsVerificator())
        let accountCreationView = AccountCreationView(viewModel: accountCreationViewModel)
        navigationController.pushViewController(UIHostingController(rootView: accountCreationView), animated: true)
    }
    
    func goingBackToHomeView() {
        navigationController.dismiss(animated: true)
    }
}

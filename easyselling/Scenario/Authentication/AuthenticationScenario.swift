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
    
    init(navigator: AccountCreationNavigator) {
        self.navigator = navigator
    }
    
    private var navigator: AccountCreationNavigator
    
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

protocol AccountCreationNavigator {
    func begin(onVehicleCreationOpen: @escaping Action)
    func navigatesToAccountCreation(onFinish: @escaping Action)
    func goingBackToHomeView()
}

class DefaultAccountCreationNavigator: AccountCreationNavigator {
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    private let navigationController: UINavigationController
    
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

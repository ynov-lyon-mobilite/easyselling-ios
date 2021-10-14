//
//  AccountCreationScenario.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation
import UIKit
import SwiftUI

class AccountCreationScenario {
    
    init(navigator: AccountCreationNavigator) {
        self.navigator = navigator
    }
    
    private var navigator: AccountCreationNavigator
    
    func begin(onFinish: @escaping Action) {
        navigator.begin(onFinish: onFinish)
    }
}

protocol AccountCreationNavigator {
    func begin(onFinish: @escaping Action)
}

class DefaultAccountCreationNavigator: AccountCreationNavigator {
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    private let navigationController: UINavigationController
    
    func begin(onFinish: @escaping Action) {
        let accountCreationViewModel = AccountCreationViewModel(verificator: DefaultInformationsVerificator())
        let accountCreationView = AccountCreationView(viewModel: accountCreationViewModel)
        navigationController.pushViewController(UIHostingController(rootView: accountCreationView), animated: true)
    }
}

//
//  AuthenticationScenario.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation

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
        navigator.begin(onAccountCreation: self.navigatesToAccountCreation,
                                    onPasswordReset: self.navigatesToPasswordResetRequest, onUserLogged: { self.navigatesToVehicles() })
        navigator.navigatesToPasswordReset(withToken: token, onPasswordReset: goingBackToHomeView)
    }

    func navigatesToVehicles() {
        navigator.navigatesToVehicles()
    }

    private func goingBackToHomeView() {
        navigator.goingBackToHomeView()
    }
}

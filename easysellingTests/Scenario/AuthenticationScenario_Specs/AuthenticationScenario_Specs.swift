//
//  AuthenticationScenario_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation
import XCTest
@testable import easyselling

class AuthenticationScenario_Specs: XCTestCase {
    
    func test_Begins_scenario() {
        givenScenario()
        whenBeginning()
        thenHistory(is: [.login])
    }
    
    func test_Begins_scenario_from_reset_password_universal_links() {
        givenScenario()
        whenBeginning(from: .resetPassword(token: ""))
        thenHistory(is: [.login, .passwordReset])
    }
    
    func test_Navigates_back_to_login_page_when_password_is_reset() {
        givenScenario()
        whenBeginning(from: .resetPassword(token: ""))
        navigator.onPasswordReset?()
        thenHistory(is: [.login, .passwordReset, .login])
    }
    
    func test_Navigates_to_account_creation() {
        givenScenario()
        whenBeginning()
        whenNavigatingToAccountCreation()
        thenHistory(is: [.login, .accountCreation])
    }
    
    func test_Leaves_account_creation() {
        givenScenario()
        whenBeginning()
        whenNavigatingToAccountCreation()
        navigator.onFinish?()
        thenHistory(is: [.login, .accountCreation, .login])
    }
    
    func test_Finishes_Scenario_when_user_is_logged() {
        givenScenario()
        whenBeginning()
        navigator.onUserLogged?()
        XCTAssertTrue(navigator.scenarioIsFinished)
    }
        
    func test_Navigates_to_password_reset() {
        givenScenario()
        whenBeginning()
        whenNavigatingToPasswordReset()
        thenHistory(is: [.login, .passwordResetRequest])
    }
    
    private func givenScenario() {
        navigator = SpyAuthenticationNavigator()
        scenario = AuthenticationScenario(navigator: navigator)
    }
    
    private func whenBeginning(from beginType: AuthenticationScenario.BeginType = .default) {
        scenario.begin(from: beginType)
    }
    
    private func whenNavigatingToAccountCreation() {
        navigator.onNavigationToAccountCreation?()
    }
    
    private func whenNavigatingToPasswordReset() {
        navigator.onNavigationToPasswordReset?()
    }
    
    private func thenHistory(is expected: [SpyAuthenticationNavigator.History]) {
        XCTAssertEqual(navigator.history, expected)
    }
    
    private var scenario: AuthenticationScenario!
    private var navigator: SpyAuthenticationNavigator!
    private var isScenarioDidFinished: Bool!
}

class SpyAuthenticationNavigator: AuthenticationNavigator {
    
    private(set) var history: [History] = []
    private(set) var onFinish: Action?
    private(set) var onNavigationToAccountCreation: Action?
    private(set) var onNavigationToPasswordReset: Action?
    private(set) var onUserLogged: Action?
    private(set) var onPasswordReset: Action?
    private(set) var scenarioIsFinished: Bool = false
    
    func navigatesToLoginPage(onAccountCreation: @escaping Action, onPasswordReset: @escaping Action, onUserLogged: @escaping Action) {
        self.onNavigationToAccountCreation = onAccountCreation
        self.onNavigationToPasswordReset = onPasswordReset
        self.onUserLogged = onUserLogged
        history.append(.login)
    }

    func navigatesToAccountCreation(onFinish: @escaping Action) {
        self.onFinish = onFinish
        history.append(.accountCreation)
    }
    
    func navigatesToPasswordResetRequest() {
        history.append(.passwordResetRequest)
    }
    
    func navigatesToPasswordReset(withToken token: String, onPasswordReset: @escaping Action) {
        self.onPasswordReset = onPasswordReset
        history.append(.passwordReset)
    }

    func goingBackToHomeView() {
        history.append(.login)
    }
    
    func navigatesToVehicles() {
        scenarioIsFinished = true
    }
    
    enum History: CustomDebugStringConvertible {
        
        case accountCreation
        case login
        case passwordResetRequest
        case passwordReset
        
        var debugDescription: String {
            switch self {
            case .accountCreation: return "Account creation"
            case .login: return "Login"
            case .passwordResetRequest: return "Password reset request"
            case .passwordReset: return "Password reset"
            }
        }
    }
}

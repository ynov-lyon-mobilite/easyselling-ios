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

    func test_Navigates_to_password_reset() {
        givenScenario()
        whenBeginning()
        whenNavigatingToPasswordReset()
        thenHistory(is: [.login, .passwordReset])
    }
    
    private func givenScenario() {
        navigator = SpyAuthenticationNavigator()
        scenario = AuthenticationScenario(navigator: navigator)
    }
    
    private func whenBeginning() {
        scenario.begin()
    }
    
    private func whenNavigatingToAccountCreation() {
        scenario.navigatesToAccountCreation()
    }
    
    private func whenNavigatingToPasswordReset() {
        scenario.navigatesToPasswordReset()
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
    private(set) var onUserLogged: Action?
    private(set) var scenarioIsFinished: Bool = false
    
    func begin(onAccountCreation: @escaping Action, onPasswordReset: @escaping Action, onUserLogged: @escaping Action) {
        self.onUserLogged = onUserLogged
        history.append(.login)
    }

    func navigatesToAccountCreation(onFinish: @escaping Action) {
        self.onFinish = onFinish
        history.append(.accountCreation)
    }
    
    func navigatesToPasswordReset() {
        history.append(.passwordReset)
    }

    func goingBackToHomeView() {
        history.append(.login)
    }
    
    func navigatesToVehicles() {
        scenarioIsFinished = true
    }
    
    enum History: CustomDebugStringConvertible{
        
        case accountCreation
        case login
        case passwordReset
        
        var debugDescription: String {
            switch self {
            case .accountCreation: return "Account creation"
            case .login: return "Login"
            case .passwordReset: return "Password reset"
            }
        }
    }
}

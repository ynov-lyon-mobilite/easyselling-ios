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
    
    func begin(onVehicleCreationOpen: @escaping Action) {
        history.append(.login)
    }

    func navigatesToAccountCreation(onFinish: @escaping Action) {
        self.onFinish = onFinish
        history.append(.accountCreation)
    }

    func goingBackToHomeView() {
        history.append(.login)
    }
    
    enum History: CustomDebugStringConvertible{
        
        case accountCreation
        case login
        
        var debugDescription: String {
            switch self {
            case .accountCreation: return "Account creation"
            case .login: return "Login"
            }
        }
    }
}

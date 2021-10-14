//
//  AccountCreationScenario.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation
import XCTest
@testable import easyselling

class AccountCreationScenario_Specs: XCTestCase {
    
    func test_Begins_scenario() {
        givenScenario()
        whenBeginning()
        thenHistory(is: [.accountCreation])
    }
    
    func test_Leaves_scenario_when_account_is_created() {
        givenScenario()
        whenBeginning()
        thenScenarioDidFinished()
    }
    
    private func givenScenario() {
        navigator = SpyAccountCreationNavigator()
        scenario = AccountCreationScenario(navigator: navigator)
    }
    
    private func whenBeginning() {
        scenario.begin(onFinish: {
            self.isScenarioDidFinished = true
        })
    }
    
    private func thenScenarioDidFinished() {
        XCTAssertTrue(isScenarioDidFinished)
    }
    
    private func thenHistory(is expected: [AccountCreationStates]) {
        XCTAssertEqual(navigator.history, [.accountCreation])
    }
    
    private var scenario: AccountCreationScenario!
    private var navigator: SpyAccountCreationNavigator!
    private var isScenarioDidFinished: Bool!
}

class SpyAccountCreationNavigator: AccountCreationNavigator {
    
    private(set) var history: [AccountCreationStates] = []
    
    func begin(onFinish: @escaping Action) {
        history.append(.accountCreation)
        onFinish()
    }
}

enum AccountCreationStates: CustomDebugStringConvertible{
    
    case accountCreation
    
    var debugDescription: String {
        switch self {
        case .accountCreation: return "Account creation"
        }
    }

}

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
        let navigator = SpyAccountCreationNavigator()
        let scenario = AccountCreationScenario(navigator: navigator)
        scenario.begin(onFinish: {})
        XCTAssertEqual(navigator.history, [.accountCreation])
    }
    
    func test_Leaves_scenario_when_account_is_created() {
        let navigator = SpyAccountCreationNavigator()
        let scenario = AccountCreationScenario(navigator: navigator)
        scenario.begin(onFinish: {
            self.isScenarioDidFinished = true
        })
        XCTAssertTrue(isScenarioDidFinished)
    }
    
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

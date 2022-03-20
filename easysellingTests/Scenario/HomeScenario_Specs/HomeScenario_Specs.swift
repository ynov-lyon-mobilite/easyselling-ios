//
//  HomeScenario_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 09/03/2022.
//

import Foundation
import XCTest
@testable import easyselling

class HomeScenario_Specs: XCTestCase {

    func test_Asserts_that_all_scenario_are_setups() {
        let navigator = SpyHomeNavigator()
        let scenario = HomeScenario(navigator: navigator)
        scenario.begin()
        XCTAssertEqual([.vehicleScenario], navigator.history)
    }
}

class SpyHomeNavigator: HomeNavigator {
    private(set) var history: [History] = []

    func navigatesToVehicles() {
        history.append(.vehicleScenario)
    }

    enum History: CustomDebugStringConvertible {
        case vehicleScenario

        var debugDescription: String {
            switch self {
            case .vehicleScenario: return "Vehicle Scenario"
            }
        }
    }
}

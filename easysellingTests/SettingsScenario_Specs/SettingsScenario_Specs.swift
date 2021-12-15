//
//  SettingsScenario_Specs.swift
//  easysellingTests
//
//  Created by Lucas Barthélémy on 15/12/2021.
//

import XCTest
@testable import easyselling

class SettingsScenario_Specs: XCTestCase {

    func test_Starts_settings_scenario() {
        givenScenario()
        whenBeginning()
        thenHistory(is: [.settings])
    }
    
    func givenScenario() {
        spyNavigator = SpySettingsNavigator()
        scenario = SettingsScenario(navigator: spyNavigator)
    }

    func whenBeginning() {
        scenario.begin()
    }

    func thenHistory(is expected: [SpySettingsNavigator.History]) {
        XCTAssertEqual(expected, spyNavigator.history)
    }

    private var spyNavigator: SpySettingsNavigator!
    private var scenario: SettingsScenario!
}

class SpySettingsNavigator: SettingsNavigator {
    private(set) var history: [History] = []

    func navigatesToSettingsView() {
        history.append(.settings)
    }

    enum History {
        case settings
    }
}

//
//  ProfileScenario_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 26/11/2021.
//

import XCTest
@testable import easyselling

class ProfileScenario_Specs: XCTestCase {

    func test_Begin_with_profile_page() {
        givenScenario()
        whenBeginning()
        thenHistory(is: [.profile])
    }

    func test_Leaves_profile_when_disconnecting() {
        givenScenario()
        whenBeginning()
        whenLogout()
        thenScenarioHasBeenLeaved()
    }

    func test_Finishes_scenario_when_navigate_to_settings_menu() {
        givenScenario()
        whenBeginning()
        whenNavigatingToSettingsMenu()
        thenHistory(is: [.profile, .settings])
        thenProfileScenarioIsFinished()
    }

    private func givenScenario() {
        navigator = SpyProfileNavigator()
        scenario = ProfileScenario(navigator: navigator)
    }

    private func whenBeginning() {
        scenario.begin()
    }

    private func whenLogout() {
        navigator.onLogout?()
    }

    private func whenNavigatingToSettingsMenu() {
        navigator.onNavigateToSettingsMenu?()
    }

    private func thenScenarioHasBeenLeaved() {
        XCTAssertTrue(navigator.isLoggingOut)
    }

    private func thenProfileScenarioIsFinished() {
        XCTAssertTrue(navigator.profileScenarioIsFinished)
    }

    private func thenHistory(is expected: [SpyProfileNavigator.History]) {
        XCTAssertEqual(expected, navigator.history)
    }

    private var scenario: ProfileScenario!
    private var navigator: SpyProfileNavigator!
}

class SpyProfileNavigator: ProfileNavigator {

    private(set) var history: [History] = []
    private(set) var onLogout: Action?
    private(set) var onNavigateToSettingsMenu: Action?
    private(set) var isLoggingOut: Bool = false
    private(set) var profileScenarioIsFinished: Bool = false

    func navigatesToProfile(onLogout: @escaping Action, onNavigateToSettingsMenu: @escaping Action) {
        self.onLogout = onLogout
        self.onNavigateToSettingsMenu = onNavigateToSettingsMenu
        history.append(.profile)
    }

    func navigatesBackToAuthentication() {
        self.isLoggingOut = true
    }

    func navigatesToSettingsMenu() {
        profileScenarioIsFinished = true
        history.append(.settings)
    }

    enum History {
        case profile
        case settings

        var debugDescription: String {
            switch self {
            case .profile: return "Profile"
            case .settings: return "settings menu"
            }
        }
    }
}

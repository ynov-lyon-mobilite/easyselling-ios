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

    private func thenScenarioHasBeenLeaved() {
        XCTAssertTrue(navigator.isLoggingOut)
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
    private(set) var isLoggingOut: Bool = false

    func navigatesToProfile(onLogout: @escaping Action) {
        self.onLogout = onLogout
        history.append(.profile)
    }

    func navigatesBackToAuthentication() {
        self.isLoggingOut = true
    }

    enum History {
        case profile

        var debugDescription: String {
            switch self {
            case .profile: return "Profile"
            }
        }
    }
}

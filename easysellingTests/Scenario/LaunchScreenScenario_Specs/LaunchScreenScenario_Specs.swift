//
//  LaunchScreenScenario_Specs.swift
//  easysellingTests
//
//  Created by Pierre Gourgouillon on 23/04/2022.
//

import Foundation
import XCTest
@testable import easyselling

class LaunchScreenScenario_Specs: XCTestCase {

    func test_Begins_scenario() async {
        givenScenario()
        whenBeginning()
        await whenLeavingScenario()
        thenHistory(is: [.launchScreen])
    }

    private func givenScenario() {
        navigator = SpyLaunchScreenNavigator()
        scenario = LaunchScreenScenario(navigator: navigator)
    }

    private func whenBeginning() {
        scenario.begin(onFinish: {
            self.isFinish = true
        })
    }

    private func whenLeavingScenario() async {
        await navigator.onFinish?()
    }

    private func thenHistory(is expected: [SpyLaunchScreenNavigator.History]) {
        XCTAssertTrue(isFinish)
        XCTAssertEqual(expected, navigator.history)
    }

    private var isFinish = false
    private var navigator: SpyLaunchScreenNavigator!
    private var scenario: LaunchScreenScenario!
}

class SpyLaunchScreenNavigator: LaunchScreenNavigator {
    private(set) var history: [History] = []
    private(set) var onFinish: AsyncableAction?

    func navigatesToLaunchScreen(onFinish: @escaping Action) {
        self.onFinish = onFinish
        history.append(.launchScreen)
    }

    enum History: CustomDebugStringConvertible {
        case launchScreen

        var debugDescription: String {
            switch self {
            case .launchScreen: return "Launch Screen"
            }
        }
    }
}

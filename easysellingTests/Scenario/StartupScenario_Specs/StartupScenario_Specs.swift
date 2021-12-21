//
//  StartupScenario_Specs.swift
//  easysellingTests
//
//  Created by Théo Tanchoux on 24/11/2021.
//

import Foundation
import XCTest
@testable import easyselling

class StartupScenario_Specs : XCTestCase {

    func test_Begins_OnBoarding_scenario() async {
        givenScenario()
        whenOnBoardingHasNeverBeenViewed()
        await whenBeginning()
        thenHistory(is: [.onBoarding])
    }

    func test_Begins_Login_scenario() async {
        givenScenario()
        whenOnBoardingHasBeenViewed()
        await whenBeginning()
        thenHistory(is: [.login])
    }

    func test_Begins_Vehicle_scenario_when_token_is_valid() async {
        givenScenario(with: FakeTokenManager(accessTokenIsExpired: false, accessToken: "ACCESS_TOKEN", refreshToken: "REFRESH_TOKEN"))
        whenOnBoardingHasBeenViewed()
        await whenBeginning()
        thenHistory(is: [.myVehicles])
    }

    func test_Begins_Vehicle_scenario_when_token_is_expired_but_refresh_from_refresh_token() async {
        givenScenario(with: FakeTokenManager(accessTokenIsExpired: true, accessToken: "ACCESS_TOKEN", refreshToken: "REFRESH_TOKEN"),
                      and: SucceedingTokenRefreshor(accessToken: "ACCESS_TOKEN"))
        whenOnBoardingHasBeenViewed()
        await whenBeginning()
        thenHistory(is: [.myVehicles])
    }

    func test_Begins_Login_scenario_when_token_and_refresh_token_are_expired() async {
        givenScenario(with: FakeTokenManager(accessTokenIsExpired: true, accessToken: "ACCESS_TOKEN", refreshToken: "REFRESH_TOKEN"),
                      and: FailingTokenRefreshor(error: APICallerError.unauthorized))
        whenOnBoardingHasBeenViewed()
        await whenBeginning()
        thenHistory(is: [.login])
    }

    private func givenScenario(with tokenManager: TokenManager = FakeTokenManager(), and tokenRefreshor: TokenRefreshor = SucceedingTokenRefreshor(accessToken: "REFRESH_TOKEN")) {
        navigator = SpyStartupNavigator()
        scenario = StartupScenario(navigator: navigator, tokenManager: tokenManager, tokenRefreshor: tokenRefreshor)
    }

    private func whenOnBoardingHasNeverBeenViewed() {
        scenario.onBoardingIsViewed = false
    }

    private func whenOnBoardingHasBeenViewed() {
        scenario.onBoardingIsViewed = true
    }

    private func whenBeginning() async {
        await scenario.begin()
    }

    private func thenHistory(is expected: [SpyStartupNavigator.History]) {
        XCTAssertEqual(expected, navigator.history)
    }

    private var scenario: StartupScenario!
    private var navigator: SpyStartupNavigator!

 }

class SpyStartupNavigator: StartupNavigator {

    private(set) var history: [History] = []

    func navigatesToOnBoarding() {
        history.append(.onBoarding)
    }

    func navigatesToLogin() {
        history.append(.login)
    }

    func navigatesToHomeView() {
        history.append(.myVehicles)
    }

    enum History: CustomDebugStringConvertible, Equatable {
        case myVehicles, onBoarding, login

        var debugDescription: String {
            switch self {
            case .myVehicles: return "My vehicles"
            case .onBoarding: return "OnBoarding"
            case .login: return "Login"
            }
        }

    }
}

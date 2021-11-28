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
        givenScenario(with: FakeTokenManager())
        givenIsOnBoardingViewed(false)
        await whenBeginning()
        thenHistory(is: [.onBoarding])
    }

    func test_Begins_Login_scenario() async {
        givenScenario(with: FakeTokenManager(), and: SucceedingTokenRefreshor(accessToken: "REFRESH_TOKEN"))
        givenIsOnBoardingViewed(true)
        await whenBeginning()
        thenHistory(is: [.login])
    }

    func test_Begins_Vehicle_scenario() async {
        givenScenario(with: succedingTokenManager(), and: SucceedingTokenRefreshor(accessToken: "REFRESH_TOKEN"))
        givenIsOnBoardingViewed(true)
        await whenBeginning()
        thenHistory(is: [.myVehicles])
    }

    func test_Begins_Vehicle_scenario_On_Refreshing_Expired_Token() async {
        givenScenario(with: tokenManagerWithTokenExpired(), and: SucceedingTokenRefreshor(accessToken: "REFRESH_TOKEN"))
        givenIsOnBoardingViewed(true)
        await whenBeginning()
        thenHistory(is: [.myVehicles])
    }

    func test_Begins_Login_scenario_If_Refresh_Fails() async {
        givenScenario(with: tokenManagerWithTokenExpired(), and: FailingTokenRefreshor(error: APICallerError.unauthorized))
        givenIsOnBoardingViewed(true)
        await whenBeginning()
        thenHistory(is: [.login])
    }

    private func givenScenario(with tokenManager: TokenManager, and tokenRefreshor: TokenRefreshor = DefaultTokenRefreshor()) {
        navigator = SpyStartupNavigator()
        scenario = StartupScenario(navigator: navigator, tokenManager: tokenManager, tokenRefreshor: tokenRefreshor)
    }

    private func succedingTokenManager() -> FakeTokenManager {
        return FakeTokenManager(accessTokenIsExpired: false, accessToken: "ACCESS_TOKEN", refreshToken: "REFRESH_TOKEN")
    }

    private func tokenManagerWithTokenExpired() -> FakeTokenManager {
        return FakeTokenManager(accessTokenIsExpired: true, accessToken: "ACCESS_TOKEN", refreshToken: "REFRESH_TOKEN")
    }

    private func givenIsOnBoardingViewed(_ viewed: Bool) {
        scenario.onBoardingIsViewed = viewed
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

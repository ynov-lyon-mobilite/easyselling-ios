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

    func test_Begins_OnBoarding_scenario() {
        givenTokenManagerIsNil()
        givenScenario(with: SucceedingTokenRefreshor(accessToken: "REFRESH_TOKEN"))
        givenOnBoardingViewed(is: false)
        whenBeginning()
        thenHistory(is: [.onBoarding])
    }

    func test_Begins_Login_scenario() {
        givenTokenManagerIsNil()
        givenScenario(with: SucceedingTokenRefreshor(accessToken: "REFRESH_TOKEN"))
        givenOnBoardingViewed(is: true)
        whenBeginning()
        thenHistory(is: [.login])
    }

    func test_Begins_Vehicle_scenario() {
        givenSuccedingTokenManager()
        givenScenario(with: SucceedingTokenRefreshor(accessToken: "REFRESH_TOKEN"))
        givenOnBoardingViewed(is: true)
        whenBeginning()
        thenHistory(is: [.myVehicles])
    }

    func test_Begins_Vehicle_scenario_If_Token_Expires() {
        givenTokenManagerWithTokenExpired()
        givenScenario(with: SucceedingTokenRefreshor(accessToken: "REFRESH_TOKEN"))
        givenOnBoardingViewed(is: true)
        whenBeginning()
        sleep(1)
        thenHistory(is: [.myVehicles])
    }

    func test_Begins_Login_scenario_If_Refresh_Fails() {
        givenTokenManagerWithTokenExpired()
        givenScenario(with: FailingTokenRefreshor(error: APICallerError.unauthorized))
        givenOnBoardingViewed(is: true)
        whenBeginning()
        sleep(1)
        thenHistory(is: [.login])
    }

    private func givenScenario(with tokenRefreshor: TokenRefreshor) {
        navigator = SpyStartupNavigator()
        scenario = StartupScenario(navigator: navigator, tokenManager: tokenManager, tokenRefreshor: tokenRefreshor)
    }

    private func givenSuccedingTokenManager() {
        tokenManager = FakeTokenManager(accessTokenIsExpired: false, accessToken: "ACCESS_TOKEN", refreshToken: "REFRESH_TOKEN")
    }

    private func givenTokenManagerWithTokenExpired() {
        tokenManager = FakeTokenManager(accessTokenIsExpired: true, accessToken: "ACCESS_TOKEN", refreshToken: "REFRESH_TOKEN")
    }

    private func givenTokenManagerIsNil() {
        tokenManager = FakeTokenManager()
    }

    private func givenOnBoardingViewed(is viewed: Bool) {
        scenario.onBoardingIsViewed = viewed
    }

    private func whenBeginning() {
        scenario.begin()
    }

    private func thenHistory(is expected: [SpyStartupNavigator.History]) {
        XCTAssertEqual(expected, navigator.history)
    }

    private var scenario: StartupScenario!
    private var navigator: SpyStartupNavigator!
    private var tokenManager: FakeTokenManager!

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

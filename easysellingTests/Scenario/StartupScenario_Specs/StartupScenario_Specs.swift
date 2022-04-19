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

    func test_Begins_Vehicle_scenario_when_user_is_authenticated() async {
        givenScenario(firebaseAuthProvider: SucceedingFirebaseAuthProvider(isAuthenticated: true))
        whenOnBoardingHasBeenViewed()
        await whenBeginning()
        thenHistory(is: [.myVehicles])
    }

//    func test_Begins_with_vehicle_info_share_when_user_is_not_authenticated_and_onboarding_has_been_seen() async {
//        givenScenario(firebaseAuthProvider: FailingFirebaseAuthProvider(error: NSError()))
//        whenOnBoardingHasBeenViewed()
//        await whenBeginning(from: .vehicleInfoShare(id: ""))
//        thenHistory(is: [.vehicleInfoShare(id: "")])
//    }

    func test_Begins_with_vehicle_info_share_when_user_is_already_authenticated() async {
        givenScenario(firebaseAuthProvider: SucceedingFirebaseAuthProvider(isAuthenticated: true))
        whenOnBoardingHasBeenViewed()
        await whenBeginning(from: .vehicleInfoShare(id: "id"))
        thenHistory(is: [.vehicleInfoShare(id: "id")])
    }

    private func givenScenario(firebaseAuthProvider: FirebaseAuthProvider = SucceedingFirebaseAuthProvider()) {
        navigator = SpyStartupNavigator()
        scenario = StartupScenario(navigator: navigator, firebaseAuthProvider: firebaseAuthProvider)
    }

    private func whenOnBoardingHasNeverBeenViewed() {
        scenario.onBoardingIsViewed = false
    }

    private func whenOnBoardingHasBeenViewed() {
        scenario.onBoardingIsViewed = true
    }

    private func whenBeginning(from beginWay: StartupScenario.BeginWay = .usual) async {
        await scenario.begin(from: beginWay)
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

    func navigatesToHomeView(withActivationId id: String) {
        history.append(.vehicleInfoShare(id: id))
    }

    enum History: CustomDebugStringConvertible, Equatable {
        case myVehicles
        case onBoarding
        case login
        case vehicleInfoShare(id: String)

        var debugDescription: String {
            switch self {
            case .myVehicles: return "My vehicles"
            case .onBoarding: return "OnBoarding"
            case .login: return "Login"
            case let .vehicleInfoShare(id): return "Share vehicle info with id \(id)"
            }
        }

    }
}

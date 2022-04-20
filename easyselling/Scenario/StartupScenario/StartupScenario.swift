//
//  StartupScenario.swift
//  easyselling
//
//  Created by Théo Tanchoux on 24/11/2021.
//

import Foundation
import SwiftUI

class StartupScenario {
    @AppStorage("onBoardingIsViewed") var onBoardingIsViewed: Bool = false
    private let navigator: StartupNavigator
    private let firebaseAuthProvider: FirebaseAuthProvider

    init(navigator: StartupNavigator, firebaseAuthProvider: FirebaseAuthProvider = DefaultFirebaseAuthProvider()) {
        self.navigator = navigator
        self.firebaseAuthProvider = firebaseAuthProvider
    }

    @MainActor func begin(from beginWay: BeginWay) async {
        switch beginWay {
        case .usual: await startFromUsualBeginType()
        case let .vehicleInfoShare(id): await startFromSharedVehicleUniversalLink(withActivationId: id)
        }
    }

    private func startFromUsualBeginType() async {
        switch await beginType() {
        case .onBoarding:
            navigator.navigatesToOnBoarding()
        case .login:
            navigator.navigatesToLogin()
        case .home:
            navigator.navigatesToHomeView()
        }
    }

    private func startFromSharedVehicleUniversalLink(withActivationId id: String) async {
        switch await beginType() {
        case .onBoarding: break
        case .login: break
        case .home: await navigator.navigatesToHomeView(withActivationId: id)
        }
    }

    private func beginType() async -> BeginType {
        if !onBoardingIsViewed {
            return .onBoarding
        } else if firebaseAuthProvider.isAuthenticated {
            return .home
        } else {
            return .login
        }
    }

    private enum BeginType {
        case onBoarding, login, home
    }

    enum BeginWay {
        case usual
        case vehicleInfoShare(id: String)
    }
}

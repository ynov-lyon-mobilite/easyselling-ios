//
//  StartupScenario.swift
//  easyselling
//
//  Created by Théo Tanchoux on 24/11/2021.
//

import Foundation
import SwiftUI

class StartupScenario {
    init(navigator: StartupNavigator,
         tokenManager: TokenManager = DefaultTokenManager.shared,
         tokenRefreshor: TokenRefreshor = DefaultTokenRefreshor()) {
        self.navigator = navigator
        self.tokenManager = tokenManager
        self.tokenRefreshor = tokenRefreshor
    }

    var onBoardingIsViewed: Bool = false
//    @AppStorage("onBoardingIsViewed") var onBoardingIsViewed: Bool = false
    private var navigator: StartupNavigator
    private var tokenManager: TokenManager
    private var tokenRefreshor: TokenRefreshor

    @MainActor func begin() async {
        switch await beginType() {
        case .onBoarding:
            navigator.navigatesToOnBoarding()
        case .login:
            navigator.navigatesToLogin()
        case .home:
            navigator.navigatesToHomeView()
        }
    }

    private func beginType() async -> BeginType {
        if !onBoardingIsViewed {
            return .onBoarding
        } else if tokenManager.accessToken != nil && !tokenManager.accessTokenIsExpired {
            return .home
        } else if let refreshToken = tokenManager.refreshToken,
                  let tokens = try? await tokenRefreshor.refresh(refreshToken: refreshToken) {
            tokenManager.setTokens(tokens)
            return .home
        } else {
            return .login
        }
    }

    private enum BeginType {
        case onBoarding, login, home
    }
}

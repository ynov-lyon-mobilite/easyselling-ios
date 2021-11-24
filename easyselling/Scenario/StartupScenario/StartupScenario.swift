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

    @AppStorage("onBoardingIsViewed") var onBoardingIsViewed: Bool = false
    private var navigator: StartupNavigator
    private var tokenManager: TokenManager
    private var tokenRefreshor: TokenRefreshor

    func begin() {
        do {
//            tokenManager.flush()
            guard let refreshToken = tokenManager.refreshToken else {
                      throw APICallerError.unauthorized
                  }

            if !tokenManager.accessTokenIsExpired {
                self.navigator.navigatesToHomeView()
            } else {
                Task {
                    let tokenResult = try await tokenRefreshor.refresh(refreshToken: refreshToken)
                    tokenManager.accessToken = tokenResult.accessToken
                    tokenManager.refreshToken = tokenResult.refreshToken
                    self.navigator.navigatesToHomeView()
                }
            }
        } catch {
            if !onBoardingIsViewed {
                self.navigator.navigatesToOnBoarding()
            } else {
                self.navigator.navigatesToLogin()
            }
        }
    }
}

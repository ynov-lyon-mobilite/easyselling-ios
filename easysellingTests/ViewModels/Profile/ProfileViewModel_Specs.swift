//
//  ProfileViewModel_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 26/11/2021.
//

import XCTest
@testable import easyselling

class ProfileViewModel_Specs: XCTestCase {

    func test_Discards_tokens_when_trying_to_logout() {
        givenViewModel(tokenManager: FakeTokenManager(accessToken: "Access token", refreshToken: "Refresh token"))
        whenTryingToLoggingOut()
        thenToken(is: nil)
        thenRefreshToken(is: nil)
    }

    func test_Leaves_on_logout() {
        givenViewModel(tokenManager: FakeTokenManager(accessToken: "Access token", refreshToken: "Refresh token"))
        whenTryingToLoggingOut()
        thenToken(is: nil)
        thenRefreshToken(is: nil)
        thenHasLoggedOut()
    }

    private func givenViewModel(tokenManager: TokenManager) {
        self.tokenManager = tokenManager
        viewModel = ProfileViewModel(tokenManager: tokenManager, onLogout: { self.hasLoggedOut = true })
    }

    private func whenTryingToLoggingOut() {
        viewModel.logout()
    }

    private func thenToken(is expected: String?) {
        XCTAssertEqual(expected, tokenManager.accessToken)
    }

    private func thenRefreshToken(is expected: String?) {
        XCTAssertEqual(expected, tokenManager.refreshToken)
    }

    private func thenHasLoggedOut() {
        XCTAssertTrue(hasLoggedOut)
    }

    private var viewModel: ProfileViewModel!
    private var tokenManager: TokenManager!
    private var hasLoggedOut: Bool = false
}

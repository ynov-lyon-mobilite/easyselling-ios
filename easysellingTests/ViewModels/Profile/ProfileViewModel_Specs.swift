//
//  ProfileViewModel_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 26/11/2021.
//

import XCTest
@testable import easyselling

class ProfileViewModel_Specs: XCTestCase {
    func test_Leaves_on_logout() async {
        givenViewModel()
        whenTryingToLoggingOut()
        await thenToken(is: nil)
        thenHasLoggedOut()
    }

    func test_Navigates_to_settings_menu() {
        givenViewModel()
        whenNavigatingToSettingsMenu()
        thenNavigatesToSettingsMenu()
    }

    private func givenViewModel(firebaseAuthProvider: FirebaseAuthProvider = SucceedingFirebaseAuthProvider()) {
        viewModel = ProfileViewModel(
            firebaseAuthProvider: firebaseAuthProvider,
            onLogout: { self.hasLoggedOut = true },
            isNavigatingToSettingsMenu: { self.onNavigateToSettingsMenu = true }
        )
    }

    private func whenTryingToLoggingOut() {
        viewModel.logout()
    }

    private func whenNavigatingToSettingsMenu() {
        viewModel.navigatesToSettingsMenu()
    }

    private func thenToken(is expected: String?) async {
        let accessToken = await viewModel.firebaseAuthProvider.getAccessToken()
        XCTAssertEqual(expected, accessToken)
    }

    private func thenHasLoggedOut() {
        XCTAssertTrue(hasLoggedOut)
    }

    private func thenNavigatesToSettingsMenu() {
        XCTAssertTrue(onNavigateToSettingsMenu)
    }

    private var viewModel: ProfileViewModel!
    private var hasLoggedOut: Bool = false
    private var onNavigateToSettingsMenu: Bool = false
}

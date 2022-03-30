//
//  UserAuthenticationViewModel_Specs.swift
//  easysellingTests
//
//  Created by Maxence on 20/10/2021.
//

import XCTest
@testable import easyselling

class UserAuthenticationViewModel_Specs: XCTestCase {
    
    func test_Shows_error_when_try_to_log_in_with_empty_credentials() async {
        givenViewModel()
        await whenUserLogin(email: "", password: "")
        thenError(is: CredentialsError.emptyEmail)
        thenAlertIsNotShown()
    }
    
    func test_Shows_error_when_try_to_log_in_with_empty_password() async {
        givenViewModel()
        await whenUserLogin(email: "user@domain.com", password: "")
        thenError(is: CredentialsError.emptyPassword)
        thenAlertIsNotShown()
    }
    
    func test_Connects_user_successfully() async {
        givenViewModel(firebaseAuthProvider: SucceedingFirebaseAuthProvider(isAuthenticated: true))
        await whenUserLogin(email: "user@domain.com", password: "PA55W0RD")
        await thenToken(expectedAccessToken: accessToken)
    }
    
    func test_Tries_login_user_with_bad_credentials() async {
        givenViewModel(firebaseAuthProvider: FailingFirebaseAuthProvider(error: APICallerError.unauthorized))
        await whenUserLogin(email: "user@domain.com", password: "PA55W0RD")
        XCTAssertEqual(APICallerError.unauthorized, viewModel.alert)
        thenAlertIsShown()
    }
    
    func test_Shows_unknow_error_when_something_unknow_fail() async {
        givenViewModel(firebaseAuthProvider: FailingFirebaseAuthProvider(error: APICallerError.unknownError))
        await whenUserLogin(email: "user@domain.com", password: "PA55W0RD")
        thenError(is: APICallerError.unknownError)
        thenAlertIsShown()
    }
    
    func test_Opens_account_creation_view() {
        givenViewModel()
        viewModel.navigateToAccountCreation()
        XCTAssertTrue(isOpeningAccountCreation)
    }
    
    func test_Opens_password_reset_view() {
        givenViewModel()
        viewModel.navigateToPasswordReset()
        XCTAssertTrue(isOpeningPasswordReset)
    }
    
    func test_Opens_Vehicles() async {
        givenViewModel()
        await whenUserLogin(email: "user@domain.com", password: "PA55W0RD")
        XCTAssertTrue(userIsLogged)
    }
    
    private func givenViewModel(firebaseAuthProvider: FirebaseAuthProvider = SucceedingFirebaseAuthProvider()) {
        viewModel = UserAuthenticationViewModel(
            firebaseAuthProvider: firebaseAuthProvider,
            navigateToAccountCreation: { self.isOpeningAccountCreation = true },
            navigateToPasswordReset: { self.isOpeningPasswordReset = true },
            onUserLogged: { self.userIsLogged = true }
        )
    }
    
    private func whenUserLogin(email: String, password: String) async {
        viewModel.email = email
        viewModel.password = password
        await viewModel.login()
    }
    
    private func thenToken(expectedAccessToken: String) async {
        let accessToken = await viewModel.firebaseAuthProvider.getAccessToken()
        XCTAssertEqual(expectedAccessToken, accessToken)
        XCTAssertNil(viewModel.error)
        XCTAssertTrue(!viewModel.showAlert)
    }
    
    private func thenError(is expectedError: LocalizedError?) {
        XCTAssertEqual(expectedError as? CredentialsError, viewModel.error)
    }
    
    private func thenAlertIsShown() {
        XCTAssertTrue(viewModel.showAlert)
    }
    
    private func thenAlertIsNotShown() {
        XCTAssertFalse(viewModel.showAlert)
    }
    
    private var viewModel: UserAuthenticationViewModel!
    private var isOpeningAccountCreation: Bool!
    private var isOpeningPasswordReset: Bool!
    private var userIsLogged: Bool = false
    
    private let accessToken = "MY_ACCESS_TOKEN"
}

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
        givenViewModel(userAuthenticator: FailingUserAuthenticator(error: .unauthorized))
        await whenUserLogin(email: "", password: "")
        thenError(is: CredentialsError.emptyEmail)
        thenAlertIsNotShown()
    }
    
    func test_Shows_error_when_try_to_log_in_with_empty_password() async {
        givenViewModel(userAuthenticator: FailingUserAuthenticator(error: .unauthorized))
        await whenUserLogin(email: "user@domain.com", password: "")
        thenError(is: CredentialsError.emptyPassword)
        thenAlertIsNotShown()
    }
    
    func test_Connects_user_successfully() async {
        givenViewModel(userAuthenticator: SucceedingUserAuthenticator())
        await whenUserLogin(email: "user@domain.com", password: "PA55W0RD")
        thenToken(expectedAccessToken: accessToken, expectedRefreshToken: refreshToken)
    }
    
    func test_Connects_user_successfully_and_state_updates() async {
        givenViewModel(userAuthenticator: SucceedingUserAuthenticator())
        await whenUserLogin(email: "user@domain.com", password: "PA55W0RD")
        thenToken(expectedAccessToken: accessToken, expectedRefreshToken: refreshToken)
    }
    
    func test_Tries_login_user_with_bad_credentials() async {
        givenViewModel(userAuthenticator: FailingUserAuthenticator(error: .unauthorized))
        await whenUserLogin(email: "user@domain.com", password: "PA55W0RD")
        XCTAssertEqual(APICallerError.unauthorized, viewModel.alert)
        thenAlertIsShown()
    }
    
    func test_Shows_unknow_error_when_something_unknow_fail() async {
        givenViewModel(userAuthenticator: FailingUserAuthenticator(error: .badGateway))
        await whenUserLogin(email: "user@domain.com", password: "PA55W0RD")
        thenError(is: APICallerError.unknownError)
        thenAlertIsShown()
    }
    
    func test_Opens_account_creation_view() {
        givenViewModel(userAuthenticator: SucceedingUserAuthenticator())
        viewModel.navigateToAccountCreation()
        XCTAssertTrue(isOpeningAccountCreation)
    }
    
    func test_Opens_password_reset_view() {
        givenViewModel(userAuthenticator: SucceedingUserAuthenticator())
        viewModel.navigateToPasswordReset()
        XCTAssertTrue(isOpeningPasswordReset)
    }
    
    func test_Opens_Vehicles() async {
        givenViewModel(userAuthenticator: SucceedingUserAuthenticator())
        await whenUserLogin(email: "user@domain.com", password: "PA55W0RD")
        XCTAssertTrue(userIsLogged)
    }
    
    private func givenViewModel(userAuthenticator: UserAuthenticatior) {
        viewModel = UserAuthenticationViewModel(userAuthenticator: userAuthenticator,
                                                tokenManager: tokenManager,
                                                navigateToAccountCreation: { self.isOpeningAccountCreation = true },
                                                navigateToPasswordReset: { self.isOpeningPasswordReset = true },
                                                onUserLogged: { self.userIsLogged = true })
    }
    
    private func whenUserLogin(email: String, password: String) async {
        viewModel.email = email
        viewModel.password = password
        await viewModel.login()
    }
    
    private func thenToken(expectedAccessToken: String, expectedRefreshToken: String) {
        XCTAssertEqual(expectedRefreshToken, tokenManager.refreshToken)
        XCTAssertEqual(expectedAccessToken, tokenManager.accessToken)
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
    private var tokenManager = FakeTokenManager()
    private var requestResult: Token!
    private var isOpeningAccountCreation: Bool!
    private var isOpeningPasswordReset: Bool!
    private var userIsLogged: Bool = false
    
    private let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImRkMzEwYTUzLWZmZTYtNDY5YS05NWRmLWRlNGE4OGE1ZTU5ZiIsImlhdCI6MTYzNDY3NjQ1OSwiZXhwIjoxNjM0Njc3MzU5LCJpc3MiOiJkaXJlY3R1cyJ9.lsMJA8Dvbu3muCZ77gYPDqdIYELrWlJsPh4e0A6tJxI"
    private let refreshToken = "wcA0WsKCAIA8ywcGt8jlsWKn-1MGKyGZcembTHsWfgmoQ3aTUnsPHCU_MIveDsr5"
}

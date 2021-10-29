//
//  UserAuthenticationViewModel_Specs.swift
//  easysellingTests
//
//  Created by Maxence on 20/10/2021.
//

import XCTest
@testable import easyselling

class UserAuthenticationViewModel_Specs: XCTestCase {
    
    func test_Connects_with_empty_password_and_email() async {
        givenViewModel(userAuthenticator: SucceedingUserAuthenticator())
        await whenUserLogin(email: "", password: "")
        thenError(is: .emptyEmail)
    }
    
    func test_Connects_with_empty_password() async {
        givenViewModel(userAuthenticator: SucceedingUserAuthenticator())
        await whenUserLogin(email: "user@domain.com", password: "")
        thenError(is: .emptyPassword)
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
        thenError(is: .badCredentials)
    }
    
    func test_Fails_with_any_other_error() async {
        givenViewModel(userAuthenticator: FailingUserAuthenticator(error: .badGateway))
        await whenUserLogin(email: "user@domain.com", password: "PA55W0RD")
        thenError(is: .unknow)
    }
    
    func test_Opens_account_creation_view() {
        givenViewModel(userAuthenticator: SucceedingUserAuthenticator())
        viewModel.navigateToAccountCreation()
        XCTAssertTrue(viewIsOpen)
    }
    
    private func givenViewModel(userAuthenticator: UserAuthenticatior) {
        tokenManager = TokenManager(keychain: .unitTestsKeychain)
        viewModel = UserAuthenticationViewModel(navigateToAccountCreation: { self.viewIsOpen = true },
                                                userAuthenticator: userAuthenticator, tokenManager: tokenManager)
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
    }
    
    private func thenError(is expectedError: UserAuthenticationViewModel.ViewModelError) {
        XCTAssertEqual(expectedError, viewModel.error)
    }
    
    private var viewModel: UserAuthenticationViewModel!
    private var tokenManager: TokenManager!
    private var requestResult: Token!
    private var viewIsOpen: Bool!
    
    private let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImRkMzEwYTUzLWZmZTYtNDY5YS05NWRmLWRlNGE4OGE1ZTU5ZiIsImlhdCI6MTYzNDY3NjQ1OSwiZXhwIjoxNjM0Njc3MzU5LCJpc3MiOiJkaXJlY3R1cyJ9.lsMJA8Dvbu3muCZ77gYPDqdIYELrWlJsPh4e0A6tJxI"
    private let refreshToken = "wcA0WsKCAIA8ywcGt8jlsWKn-1MGKyGZcembTHsWfgmoQ3aTUnsPHCU_MIveDsr5"
}

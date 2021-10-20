//
//  UserAuthenticationViewModel_Specs.swift
//  easysellingTests
//
//  Created by Maxence on 20/10/2021.
//

import XCTest
@testable import easyselling

class UserAuthenticationViewModel_Specs: XCTestCase {
    
    func test_Connects_user_successfully() async {
        let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImRkMzEwYTUzLWZmZTYtNDY5YS05NWRmLWRlNGE4OGE1ZTU5ZiIsImlhdCI6MTYzNDY3NjQ1OSwiZXhwIjoxNjM0Njc3MzU5LCJpc3MiOiJkaXJlY3R1cyJ9.lsMJA8Dvbu3muCZ77gYPDqdIYELrWlJsPh4e0A6tJxI"
        let refreshToken = "wcA0WsKCAIA8ywcGt8jlsWKn-1MGKyGZcembTHsWfgmoQ3aTUnsPHCU_MIveDsr5"
        
        givenViewModel(userAuthenticator: SucceedingUserAuthenticator())
        await whenUserLogin()
        thenToken(expectedAccessToken: accessToken, expectedRefreshToken: refreshToken)
    }
    
    func test_Connects_user_bad_credentials() async {
        givenViewModel(userAuthenticator: FailingUserAuthenticator(error: .unauthorized))
        await whenUserLogin()
        thenError(is: .unauthorized)
    }
    
    private func givenViewModel(userAuthenticator: UserAuthenticatior) {
        viewModel = UserAuthenticationViewModel(userAuthenticator: userAuthenticator)
    }
    
    private func whenUserLogin() async {
        await viewModel.login(mail: "user@domain.com", password: "PA55W0RD")
    }
    
    private func thenToken(expectedAccessToken: String, expectedRefreshToken: String) {
        XCTAssertEqual(expectedRefreshToken, viewModel.token?.refreshToken)
        XCTAssertEqual(expectedAccessToken, viewModel.token?.accessToken)
        XCTAssertNil(viewModel.error)
    }
    
    private func thenError(is expectedError: APICallerError) {
        XCTAssertEqual(expectedError, viewModel.error)
        XCTAssertNil(viewModel.token)
    }
    
    private var viewModel: UserAuthenticationViewModel!
    private var requestResult: Token!
}

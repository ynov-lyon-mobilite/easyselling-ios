//
//  DefaultUserAuthenticator_Specs.swift
//  easysellingTests
//
//  Created by Maxence on 19/10/2021.
//

import XCTest
@testable import easyselling

class DefaultUserAuthenticator_Specs: XCTestCase {
    
    func test_Login_user_succesfully() async {
        givenUserAuthenticator()
        await whenLoginUser(mail: "user@domain.com", password: "password")
        thenToken(expectedAccessToken: accessToken, expectedRefreshToken: refreshToken)
    }
    
    func test_Login_user_failed_because_needed_otp() async {
        givenUserAuthenticator(error: .unauthorized)
        await whenLoginUser(mail: "user@domain.com", password: "password")
        thenError(is: .unauthorized)
    }
    
    private func givenUserAuthenticator() {
        let data = httpResponse.data(using: .utf8)!
        userAuthenticator = DefaultUserAuthenticator(urlSession: FakeUrlSession(with: data))
    }
    
    private func givenUserAuthenticator(error: APICallerError) {
        userAuthenticator = DefaultUserAuthenticator(urlSession: FakeUrlSession(error: error))
    }
    
    private func whenLoginUser(mail: String, password: String) async {
        do {
            self.requestResult = try await userAuthenticator.login(mail: mail, password: mail)
        } catch (let error) {
            self.requestError = (error as! APICallerError)
        }
    }
    
    private func thenToken(expectedAccessToken: String, expectedRefreshToken: String) {
        XCTAssertNil(requestError)
        XCTAssertEqual(expectedRefreshToken, requestResult.refreshToken)
        XCTAssertEqual(expectedAccessToken, requestResult.accessToken)
    }
    
    private func thenError(is expectedError: APICallerError) {
        XCTAssertNil(requestResult)
        XCTAssertEqual(expectedError, requestError)
    }
    
    private var userAuthenticator: UserAuthenticatior!
    private var requestResult: Token!
    private var requestError: APICallerError!
    
    private let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImRkMzEwYTUzLWZmZTYtNDY5YS05NWRmLWRlNGE4OGE1ZTU5ZiIsImlhdCI6MTYzNDY3NjQ1OSwiZXhwIjoxNjM0Njc3MzU5LCJpc3MiOiJkaXJlY3R1cyJ9.lsMJA8Dvbu3muCZ77gYPDqdIYELrWlJsPh4e0A6tJxI"
    private let refreshToken = "wcA0WsKCAIA8ywcGt8jlsWKn-1MGKyGZcembTHsWfgmoQ3aTUnsPHCU_MIveDsr5"
    private var httpResponse: String {
        return "{\"data\":{\"access_token\": \"\(accessToken)\", \"expires\": 900000, \"refresh_token\": \"\(refreshToken)\"}}"
    }
}

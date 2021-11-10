//
//  DefaultTokenRefreshor_Specs.swift
//  easysellingTests
//
//  Created by Maxence on 02/11/2021.
//

import XCTest
@testable import easyselling

class DefaultTokenRefreshor_Specs: XCTestCase {

    func test_Refreshs_token_succesfully() async {
        givenTokenRefreshor(urlSession: FakeUrlSession(localFile: .userAuthenticatorResponse))
        await whenRefreshToken(refreshToken: "ANY_REFRESH_TOKEN")
        thenToken(expectedAccessToken: expectedAccessToken, expectedRefreshToken: expectedRefreshToken)
    }
    
    func test_Throws_error_when_token_refresh_failed() async {
        givenTokenRefreshor(urlSession: FakeUrlSession(error: .unauthorized))
        await whenRefreshToken(refreshToken: "ANY_REFRESH_TOKEN")
        thenError(is: .unauthorized)
    }
    
    private func givenTokenRefreshor(urlSession: URLSessionProtocol) {
        tokenRefreshor = DefaultTokenRefreshor(apiCaller: DefaultAPICaller(urlSession: urlSession))
    }
    
    private func whenRefreshToken(refreshToken: String) async {
        do {
            self.requestResult = try await tokenRefreshor.refresh(refreshToken: refreshToken)
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
    
    private var tokenRefreshor: TokenRefreshor!
    private var requestResult: Token!
    private var requestError: APICallerError!

    private let expectedAccessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImRkMzEwYTUzLWZmZTYtNDY5YS05NWRmLWRlNGE4OGE1ZTU5ZiIsImlhdCI6MTYzNDY3NjQ1OSwiZXhwIjoxNjM0Njc3MzU5LCJpc3MiOiJkaXJlY3R1cyJ9.lsMJA8Dvbu3muCZ77gYPDqdIYELrWlJsPh4e0A6tJxI"
    private let expectedRefreshToken = "wcA0WsKCAIA8ywcGt8jlsWKn-1MGKyGZcembTHsWfgmoQ3aTUnsPHCU_MIveDsr5"
}

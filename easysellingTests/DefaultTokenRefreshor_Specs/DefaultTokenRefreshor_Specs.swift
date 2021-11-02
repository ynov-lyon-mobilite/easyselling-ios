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
        givenTokenRefreshor()
        await whenRefreshToken(refreshToken: "ANY_REFRESH_TOKEN")
        thenToken(expectedAccessToken: accessToken, expectedRefreshToken: refreshToken)
    }
    
    func test_Refreshs_token_failed() async {
        givenTokenRefreshor(error: .unauthorized)
        await whenRefreshToken(refreshToken: "ANY_REFRESH_TOKEN")
        thenError(is: .unauthorized)
    }
    
    private func givenTokenRefreshor() {
        let data = httpResponse.data(using: .utf8)!
        tokenRefreshor = DefaultTokenRefreshor(urlSession: FakeUrlSession(with: data))
    }
    
    private func givenTokenRefreshor(error: APICallerError) {
        tokenRefreshor = DefaultTokenRefreshor(urlSession: FakeUrlSession(error: error))
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
    
    private let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImRkMzEwYTUzLWZmZTYtNDY5YS05NWRmLWRlNGE4OGE1ZTU5ZiIsImlhdCI6MTYzNDY3NjQ1OSwiZXhwIjoxNjM0Njc3MzU5LCJpc3MiOiJkaXJlY3R1cyJ9.lsMJA8Dvbu3muCZ77gYPDqdIYELrWlJsPh4e0A6tJxI"
    private let refreshToken = "wcA0WsKCAIA8ywcGt8jlsWKn-1MGKyGZcembTHsWfgmoQ3aTUnsPHCU_MIveDsr5"
    private var httpResponse: String {
        return "{\"data\":{\"access_token\": \"\(accessToken)\", \"expires\": 900000, \"refresh_token\": \"\(refreshToken)\"}}"
    }
}

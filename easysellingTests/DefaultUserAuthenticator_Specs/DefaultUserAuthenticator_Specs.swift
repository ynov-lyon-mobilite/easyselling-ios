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
        let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImRkMzEwYTUzLWZmZTYtNDY5YS05NWRmLWRlNGE4OGE1ZTU5ZiIsImlhdCI6MTYzNDY3NjQ1OSwiZXhwIjoxNjM0Njc3MzU5LCJpc3MiOiJkaXJlY3R1cyJ9.lsMJA8Dvbu3muCZ77gYPDqdIYELrWlJsPh4e0A6tJxI"
        let refreshToken = "wcA0WsKCAIA8ywcGt8jlsWKn-1MGKyGZcembTHsWfgmoQ3aTUnsPHCU_MIveDsr5"
        let httpResponse = "{\"data\":{\"access_token\": \"\(accessToken)\", \"expires\": 900000, \"refresh_token\": \"\(refreshToken)\"}}"

        givenUserAuthenticator(data: httpResponse.data(using: .utf8)!)
        await whenLoginUser()
        thenToken(expectedAccessToken: accessToken, expectedRefreshToken: refreshToken)
    }
    
    func test_Login_user_failed_because_needed_otp() async {
        let expectedResponse = HTTPURLResponse(url: URL(string: "https://easyselling.maxencemottard.com/auth/login")!,
                                               statusCode: 401,httpVersion: nil, headerFields: nil)!
        
        givenUserAuthenticator(response: expectedResponse)
        await whenLoginUser()
        thenError(is: .unauthorized)
    }
    
    private func givenUserAuthenticator(data: Data) {
        userAuthenticator = DefaultUserAuthenticator(urlSession: FakeUrlSession(with: data))
    }
    
    private func givenUserAuthenticator(response expectedResponse: HTTPURLResponse) {
        userAuthenticator = DefaultUserAuthenticator(urlSession: FakeUrlSession(expected: expectedResponse))
    }
    
    private func whenLoginUser() async {
        do {
            self.requestResult = try await userAuthenticator.login(mail: "user@domain.com", password: "password")
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
}

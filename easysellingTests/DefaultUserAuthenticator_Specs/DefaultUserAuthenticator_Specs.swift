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
        let apiCaller = DefaultAPICaller(urlSession: FakeUrlSession(localFile: .userAuthenticatorResponse))
        
        givenUserAuthenticator(apiCaller: apiCaller)
        await whenLoginUser(mail: "user@domain.com", password: "password")
        thenToken(expectedAccessToken: expectedAccessToken, expectedRefreshToken: expectedRefreshToken)
    }
    
    func test_Login_user_failed_because_needed_otp() async {
        givenUserAuthenticator(apiCaller: FailingAPICaller(withError: 401))
        await whenLoginUser(mail: "user@domain.com", password: "password")
        thenError(is: .unauthorized)
    }
    
    private func givenUserAuthenticator(apiCaller: APICaller) {
        userAuthenticator = DefaultUserAuthenticator(apiCaller: apiCaller)
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
    
    private let expectedAccessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImRkMzEwYTUzLWZmZTYtNDY5YS05NWRmLWRlNGE4OGE1ZTU5ZiIsImlhdCI6MTYzNDY3NjQ1OSwiZXhwIjoxNjM0Njc3MzU5LCJpc3MiOiJkaXJlY3R1cyJ9.lsMJA8Dvbu3muCZ77gYPDqdIYELrWlJsPh4e0A6tJxI"
    private let expectedRefreshToken = "wcA0WsKCAIA8ywcGt8jlsWKn-1MGKyGZcembTHsWfgmoQ3aTUnsPHCU_MIveDsr5"
}

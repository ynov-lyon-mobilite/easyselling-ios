//
//  DefaultUserAuthentication_Specs.swift
//  easysellingTests
//
//  Created by Maxence on 15/10/2021.
//

import XCTest
import Combine
@testable import easyselling

class DefaultUserAuthenticator_Specs: XCTestCase {

    func test_Creates_account_successfully() {
        let requestGenerator = FakeRequestGenerator()
        let expectedResponse = "{ \"data\": { \"access_token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1ODgyNjM2LWIzN2UtNDI0NC1iNDk4LWY0NGZkNWI5ODM5ZiIsImlhdCI6MTYzNDI2ODQwMiwiZXhwIjoxNjM0MjY5MzAyLCJpc3MiOiJkaXJlY3R1cyJ9._ncKuLsF991JDyJj8K5B7-7WL7I9J1TWmgwzNHFgWsY\", \"expires\": 900000, \"refresh_token\": \"olAiARC3VRdevbCiG1C0mh1UcRf2mPXHFgPT6o6TEyP6a7SZ5PtUctRYoMxBT5Q1\" } }"
        let apiCaller = SucceedingAPICaller(data: expectedResponse.data(using: .utf8))
        let userAuthenticator = DefaultUserAuthenticator(requestGenerator: requestGenerator, apiCaller: apiCaller)
        
        userAuthenticator.login(mail: "user@domain.com", password: "azertyuiop", otp: nil)
            .sink {
                switch $0 {
                case .failure(_): break
                case .finished: break
                }
            } receiveValue: {
                self.expectation.fulfill()
                self.requestResult = $0
            }.store(in: &cancellables)
            wait(for: [expectation], timeout: 3)
        
        let expectedToken = TokenResponse(accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1ODgyNjM2LWIzN2UtNDI0NC1iNDk4LWY0NGZkNWI5ODM5ZiIsImlhdCI6MTYzNDI2ODQwMiwiZXhwIjoxNjM0MjY5MzAyLCJpc3MiOiJkaXJlY3R1cyJ9._ncKuLsF991JDyJj8K5B7-7WL7I9J1TWmgwzNHFgWsY",
                                  expires: 900000,
                                  refreshToken: "olAiARC3VRdevbCiG1C0mh1UcRf2mPXHFgPT6o6TEyP6a7SZ5PtUctRYoMxBT5Q1"
        )
        
        XCTAssertEqual(expectedToken, self.requestResult)
//        accountCreator.createAccount(informations: AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "password"))
//            .sink {
//                switch $0 {
//                case .failure(_): break
//                case .finished: break
//                }
//            } receiveValue: {
//                self.expectation.fulfill()
//                self.isRequestSucceed = true
//            }
//            .store(in: &cancellables)
//        wait(for: [expectation], timeout: 3)
//
//        XCTAssertTrue(isRequestSucceed)
    }
    
    private var cancellables = Set<AnyCancellable>()
    private lazy var expectation = expectation(description: "Should finish request")
    private var error: HTTPError!
    private var requestResult: TokenResponse!
}

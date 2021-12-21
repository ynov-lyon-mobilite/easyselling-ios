//
//  DefaultPasswordResetRequester_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 07/11/2021.
//

import XCTest
@testable import easyselling

class DefaultPasswordResetRequester_Specs: XCTestCase {
    
    func test_Sends_password_reset_request_successfully() async {
        givenPasswordResetRequester()
        await whenAskingForNewPassword(for: "test@test.com")
        thenRequestSucceed()
    }
    
    func test_Throws_error_when_password_reset_request_Failed() async {
        givenPasswordResetRequester(apiCaller: FailingAPICaller(withError: 404))
        await whenAskingForNewPassword(for: "test@test.com")
        thenRequestFailed()
        thenErrorThrows(is: .notFound)
    }
    
    private func givenPasswordResetRequester(requestGenerator: RequestGenerator = FakeRequestGenerator(), apiCaller: APICaller = SucceedingAPICaller()) {
        
        requester = DefaultPasswordResetRequester(requestGenerator: requestGenerator,
                                                  apiCaller: apiCaller)
    }
    
    private func whenAskingForNewPassword(for email: String) async {
        do {
            try await requester.askForPasswordReset(of: email)
            self.isRequestSucceed = true
        } catch(let error) {
            self.thrownError = error as? APICallerError
        }
    }
    
    private func thenRequestSucceed() {
        XCTAssertTrue(isRequestSucceed)
    }
    
    private func thenRequestFailed() {
        XCTAssertFalse(isRequestSucceed)
    }
    
    private func thenErrorThrows(is expected: APICallerError) {
        XCTAssertEqual(expected, thrownError)
    }
    
    private var requester: DefaultPasswordResetRequester!
    private var isRequestSucceed: Bool = false
    private var thrownError: APICallerError!
}

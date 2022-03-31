//
//  DefaultAccountCreator_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation
import Combine
import XCTest
@testable import easyselling

class DefaultAccountCreator_Specs: XCTestCase {
    
    func test_Creates_account_successfully() async {
        givenAccountCreator(requestGenerator: FakeRequestGenerator(), apiCaller: SucceedingAPICaller())
        await whenCreatingAccount()
        thenAccountIsCreated()
    }
    
    func test_Creates_account_failed_with_wrong_url() async {
        givenAccountCreator(requestGenerator: FakeRequestGenerator(), apiCaller: FailingAPICaller(withError: 400))
        await whenCreatingAccount()
        thenErrorCode(is: 400)
        thenErrorMessage(is: APICallerError.internalServerError.errorDescription)
    }
    
    func test_Creates_account_failed_with_forbidden_access() async {
        givenAccountCreator(requestGenerator: FakeRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        await whenCreatingAccount()
        thenErrorCode(is: 404)
        thenErrorMessage(is: APICallerError.notFound.errorDescription)
    }
    
    private func givenAccountCreator(requestGenerator: RequestGenerator, apiCaller: APICaller) {
        accountCreator = DefaultAccountCreator(requestGenerator: requestGenerator, apiCaller: apiCaller)
    }
    
    private func whenCreatingAccount() async {
        do {
            try await accountCreator.createAccount(informations: AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "password"))
            self.isRequestSucceed = true
        } catch (let error) {
            self.error = (error as! APICallerError)
        }
    }
    
    private func thenAccountIsCreated() {
        XCTAssertTrue(isRequestSucceed)
    }
    
    private func thenErrorCode(is expected: Int) {
        XCTAssertEqual(expected, error.rawValue)
    }
    
    private func thenErrorMessage(is expected: String?) {
        XCTAssertEqual(expected, error.errorDescription)
    }
    
    private var accountCreator: DefaultAccountCreator!
    private var isRequestSucceed: Bool!
    private var error: APICallerError!
}

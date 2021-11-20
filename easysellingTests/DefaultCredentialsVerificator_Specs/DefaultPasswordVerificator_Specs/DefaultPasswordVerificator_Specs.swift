//
//  DefaultPasswordVerificator_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 12/11/2021.
//

import XCTest
@testable import easyselling

class DefaultPasswordVerificator_Specs: XCTestCase {
    
    func test_Shows_error_when_passwords_are_not_matching() {
        givenVerificator()
        whenVerifying(password: "password", passwordConfirmation: "wrongPassword")
        thenError(is: .wrongPassword)
    }
    
    func test_Shows_error_when_password_is_empty() {
        givenVerificator()
        whenVerifying(password: "", passwordConfirmation: "password")
        thenError(is: .emptyPassword)
    }
    
    func test_Shows_error_when_password_confirmation_is_empty() {
        givenVerificator()
        whenVerifying(password: "password", passwordConfirmation: "")
        thenError(is: .emptyPasswordConfirmation)
    }
    
    func test_Verify_passwords() {
        givenVerificator()
        whenVerifying(password: "password", passwordConfirmation: "password")
        thenPasswordHasBeenVerified()
    }
    
    private func givenVerificator() {
        verificator = DefaultPasswordVerificator()
    }
    
    private func whenVerifying(password: String, passwordConfirmation: String) {
        do {
            try verificator.verify(password: password, passwordConfirmation: passwordConfirmation)
            self.verifyingHasSucceed = true
        } catch(let error) {
            self.error = error as? CredentialsError
        }
    }
    
    private func thenPasswordHasBeenVerified() {
        XCTAssertTrue(verifyingHasSucceed)
    }
    
    private func thenError(is expected: CredentialsError) {
        XCTAssertEqual(expected, error)
    }
    
    private var verificator: DefaultPasswordVerificator!
    private var error: CredentialsError!
    private var verifyingHasSucceed: Bool = false
}

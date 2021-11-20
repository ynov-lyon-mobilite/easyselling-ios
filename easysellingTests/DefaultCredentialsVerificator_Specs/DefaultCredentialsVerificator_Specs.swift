//
//  DefaultCredentialsVerificator_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation
import XCTest
@testable import easyselling

class DefaultCredentialsVerificator_Specs: XCTestCase {
    
    func test_Verifies_informations_are_good() {
        givenVerificator()
        whenVerifying(email: "test@test.com", password: "password", passwordConfirmation: "password")
        thenInformationsVerified()
    }
    
    func test_Shows_error_when_passwords_are_not_matching() {
        givenVerificator()
        whenVerifying(email: "test@test.com", password: "password", passwordConfirmation: "wrongPassword")
        thenError(is: .wrongPassword)
    }
    
    func test_Shows_error_when_email_is_not_correct() {
        givenVerificator()
        whenVerifying(email: "test", password: "password", passwordConfirmation: "password")
        thenError(is: .wrongEmail)
    }
    
    func test_Shows_error_when_email_is_not_correct2() {
        givenVerificator()
        whenVerifying(email: "test@test", password: "password", passwordConfirmation: "password")
        thenError(is: .wrongEmail)
    }
    
    func test_Shows_error_when_email_is_not_correct3() {
        givenVerificator()
        whenVerifying(email: "test.com", password: "password", passwordConfirmation: "password")
        thenError(is: .wrongEmail)
    }

    func test_Shows_error_when_email_is_empty() {
        givenVerificator()
        whenVerifying(email: "", password: "password", passwordConfirmation: "password")
        thenError(is: .emptyEmail)
    }
    
    func test_Shows_error_when_password_is_empty() {
        givenVerificator()
        whenVerifying(email: "test@test.com", password: "", passwordConfirmation: "password")
        thenError(is: .emptyPassword)
    }
    
    func test_Shows_error_when_password_confirmation_is_empty() {
        givenVerificator()
        whenVerifying(email: "test@test.com", password: "password", passwordConfirmation: "")
        thenError(is: .emptyPasswordConfirmation)
    }
    
    func test_Deinits_when_no_longer_interested() {
        givenVerificator()
        whenVerifying(email: "test@test.com", password: "password", passwordConfirmation: "")
        whenNoLongerInterested()
        XCTAssertNil(verificator)
    }
    
    private func givenVerificator() {
        verificator = DefaultCredentialsVerificator()
    }
    
    private func whenVerifying(email: String, password: String, passwordConfirmation: String) {
        do {
            try verificator.verify(email: email, password: password, passwordConfirmation: passwordConfirmation)
            self.isVerified = true
        } catch(let error) {
            self.accountCreationError = (error as! CredentialsError)
        }
    }
    
    private func whenNoLongerInterested() {
        verificator = nil
    }
    
    private func thenInformationsVerified() {
        XCTAssertTrue(isVerified)
    }
    
    private func thenError(is expected: CredentialsError) {
        XCTAssertEqual(expected.errorDescription, accountCreationError.errorDescription)
        XCTAssertEqual(expected, accountCreationError)
    }
    
    private var verificator: DefaultCredentialsVerificator!
    private var accountCreationError: CredentialsError!
    private var isVerified: Bool = false
}

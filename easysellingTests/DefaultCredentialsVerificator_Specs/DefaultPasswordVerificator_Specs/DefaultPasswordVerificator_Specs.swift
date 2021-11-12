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
    
    func test_Returns_PasswordResetDTO_when_verification_is_ok() {
        givenVerificator()
        whenVerifying(password: "password", passwordConfirmation: "password")
        thenReturn(is: PasswordResetDTO(password: "password", token: ""))
    }
    
    private func givenVerificator() {
        verificator = DefaultPasswordVerificator()
    }
    
    private func whenVerifying(password: String, passwordConfirmation: String) {
        do {
            self.verifyiedPassword = try verificator.verify(password: password, passwordConfirmation: passwordConfirmation)
        } catch(let error) {
            self.error = error as? CredentialsError
        }
    }
    
    private func thenError(is expected: CredentialsError) {
        XCTAssertEqual(expected, error)
    }
    
    private func thenReturn(is expected: PasswordResetDTO) {
        
    }
    
    private var verificator: DefaultPasswordVerificator!
    private var error: CredentialsError!
    private var verifyiedPassword: PasswordResetDTO!
}

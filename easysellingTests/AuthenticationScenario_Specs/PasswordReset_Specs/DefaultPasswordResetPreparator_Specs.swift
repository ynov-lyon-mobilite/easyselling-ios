//
//  DefaultPasswordResetPreparator_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 17/11/2021.
//

import XCTest
@testable import easyselling

class DefaultPasswordResetPreparator_Specs: XCTestCase {
    
    func test_Prepares_password_into_DTO() {
        givenPreparator()
        whenPreparingToDTO("password", and: "password")
        thenPreparedDTO(is: PasswordResetDTO(password: "password", token: ""))
    }
    
    func test_Throws_error_when_verifies_password_failed() {
        givenPreparator()
        whenPreparingToDTO("password", and: "wrongPasswordConfirmation")
        XCTAssertEqual(.wrongPassword, error)
    }
    
    private func givenPreparator() {
        preparator = DefaultPasswordResetPreparator(verificator: DefaultPasswordVerificator(), transformator: DefaultPasswordResetTransformator())
    }
    
    private func whenPreparingToDTO(_ password: String, and passwordConfirmation: String) {
        do {
            preparedDTO = try preparator.prepare(password, passwordConfirmation: passwordConfirmation)
        } catch(let error) {
            self.error = error as? CredentialsError
        }
    }
    
    private func thenPreparedDTO(is expected: PasswordResetDTO) {
        XCTAssertEqual(expected, preparedDTO)
    }
    
    private var preparator: DefaultPasswordResetPreparator!
    private var preparedDTO: PasswordResetDTO!
    private var error: CredentialsError!
}

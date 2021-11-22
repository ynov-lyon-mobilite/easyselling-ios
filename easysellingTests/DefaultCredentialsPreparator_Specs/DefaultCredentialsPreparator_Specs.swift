//
//  DefaultCredentialsPreparator_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 20/11/2021.
//

import XCTest
@testable import easyselling

class DefaultCredentialsPreparator_Specs: XCTestCase {
    
    func test_Prepares_credentials_into_AccountCreationInformations() {
        givenPreparator(verificator: SucceedingInformationsVerificator())
        whenPreparingToCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "passwordConfirmation")
        thenCreationInformation(is: AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "passwordConfirmation"))
    }
    
    func test_Throws_error_when_verifies_password_failed() {
        givenPreparator(verificator: FailingInformationsVerificator(error: .wrongPassword))
        whenPreparingToCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "wrongPasswordConfirmation")
        XCTAssertEqual(.wrongPassword, error)
    }
    
    private func givenPreparator(verificator: CredentialsVerificator = SucceedingInformationsVerificator()) {
        preparator = DefaultCredentialsPreparator(verificator: verificator, transformator: DefaultCredentialsTransformator())
    }
    
    private func whenPreparingToCreationInformations(email: String, password: String, passwordConfirmation: String) {
        do {
            accountCreationInformations = try preparator.prepare(email: email, password: password,  passwordConfirmation: passwordConfirmation)
        } catch(let error) {
            self.error = error as? CredentialsError
        }
    }
    
    private func thenCreationInformation(is expected: AccountCreationInformations) {
        XCTAssertEqual(expected, accountCreationInformations)
    }
    
    private var preparator: DefaultCredentialsPreparator!
    private var accountCreationInformations: AccountCreationInformations!
    private var error: CredentialsError!
}

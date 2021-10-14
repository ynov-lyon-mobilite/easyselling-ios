//
//  InformationsVerificator_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation
import XCTest
@testable import easyselling

class InformationsVerificator_Specs: XCTestCase {
    
    func test_Verifies_informations_are_good() {
        let informations = AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "password")
        
        givenVerificator()
        whenVerifying(informations)
        thenInformationsAreCorrect()
    }
    
    func test_Shows_error_when_passwords_are_not_matching() {
        let informations = AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "wrongPassword")

        givenVerificator()
        whenVerifying(informations)
        thenErrorMessage(is: "Les mots de passes sont différents")
    }
    
    func test_Shows_error_when_email_is_not_correct() {
        let informations = AccountCreationInformations(email: "test", password: "password", passwordConfirmation: "password")
        
        givenVerificator()
        whenVerifying(informations)
        XCTAssertEqual("L'addresse email est incorrect", accountCreationError)
    }
    
    func test_Shows_error_when_email_is_not_correct2() {
        let informations = AccountCreationInformations(email: "test@test", password: "password", passwordConfirmation: "password")
        
        givenVerificator()
        whenVerifying(informations)
        XCTAssertEqual("L'addresse email est incorrect", accountCreationError)
    }
    
    func test_Shows_error_when_email_is_not_correct3() {
        let informations = AccountCreationInformations(email: "test.com", password: "password", passwordConfirmation: "password")
        
        givenVerificator()
        whenVerifying(informations)
        XCTAssertEqual("L'addresse email est incorrect", accountCreationError)
    }

    func test_Shows_error_when_email_is_empty() {
        let informations = AccountCreationInformations(email: "", password: "password", passwordConfirmation: "password")
        
        givenVerificator()
        whenVerifying(informations)
        XCTAssertEqual("L'addresse email est vide", accountCreationError)
    }
    
    func test_Shows_error_when_password_is_empty() {
        let informations = AccountCreationInformations(email: "test@test.com", password: "", passwordConfirmation: "password")
        
        givenVerificator()
        whenVerifying(informations)
        XCTAssertEqual("Le mot de passe est vide", accountCreationError)
    }
    
    func test_Shows_error_when_password_confirmation_is_empty() {
        let informations = AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "")
        
        givenVerificator()
        whenVerifying(informations)
        XCTAssertEqual("La confirmation du mot de passe est vide", accountCreationError)
    }
    
    private func givenVerificator() {
        verificator = DefaultInformationsVerificator()
    }
    
    private func whenVerifying(_ informations: AccountCreationInformations) {
        verificator.verify(informations, onVerified: {
            switch $0 {
            case .success(): self.isCorrectInformations = true
            case let .failure(error): self.accountCreationError = error.errorDescription
            }
        })
    }
    
    private func thenInformationsAreCorrect() {
        XCTAssertTrue(isCorrectInformations)
    }
    
    private func thenErrorMessage(is expected: String) {
        XCTAssertEqual(expected, accountCreationError)
    }
    
    private var verificator: DefaultInformationsVerificator!
    private var accountCreationError: String!
    private var isCorrectInformations: Bool!
}

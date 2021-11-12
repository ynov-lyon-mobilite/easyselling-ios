//
//  DefaultEmailVerificator_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 04/11/2021.
//

import XCTest
@testable import easyselling

class DefaultEmailVerificator_Specs: XCTestCase {
    
    func test_Throws_error_if_email_is_empty() {
        givenVerificator()
        whenVerifying(email: "")
        thenError(is: .emptyEmail)
    }
    
    func test_Throws_error_if_email_is_wrong() {
        givenVerificator()
        whenVerifying(email: "@test.com")
        thenError(is: .wrongEmail)
    }
    
    func test_Throws_error_if_email_is_wrong2() {
        givenVerificator()
        whenVerifying(email: "test@.com")
        thenError(is: .wrongEmail)
    }
    
    func test_Throws_error_if_email_is_wrong3() {
        givenVerificator()
        whenVerifying(email: "test")
        thenError(is: .wrongEmail)
    }
    
    private func givenVerificator() {
        verificator = DefaultEmailVerificator()
    }
    
    private func whenVerifying(email: String) {
        do {
            _ = try verificator.verify(email)
        } catch(let error) {
            self.error = (error as! CredentialsError)
        }
    }
    
    private func thenError(is expected: CredentialsError) {
        XCTAssertEqual(expected, error)
    }
    
    private var verificator: DefaultEmailVerificator!
    private var error: CredentialsError!
}

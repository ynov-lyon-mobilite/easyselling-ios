//
//  PasswordResetViewModel_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 04/11/2021.
//

import XCTest
@testable import easyselling

class PasswordResetViewModel_Specs: XCTestCase {
    
    func test_Shows_error_if_mail_is_not_valid() {
        let vm = PasswordResetViewModel(verificator: FailingEmailVerificator(error: .emptyEmail))
        vm.email = ""
        vm.requestPasswordReset()
        XCTAssertEqual(CredentialsError.emptyEmail, vm.error)
    }
    
    func test_Shows_loading_when_requesting_password_reset() {
        let vm = PasswordResetViewModel(verificator: SucceedingEmailVerificator())
        XCTAssertEqual(.initial, vm.state)
        vm.email = "test@test.com"
        vm.requestPasswordReset()
        XCTAssertEqual(.loading, vm.state)
    }
}

class FailingEmailVerificator: EmailVerificator {
    
    init(error: CredentialsError) {
        self.error = error
    }
    
    private let error: CredentialsError
    
    func verify(_ email: String) throws -> String {
        throw error
    }
}

class SucceedingEmailVerificator: EmailVerificator {
    
    func verify(_ email: String) throws -> String {
        email
    }
}

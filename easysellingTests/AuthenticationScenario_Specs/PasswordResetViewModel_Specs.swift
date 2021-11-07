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
        givenViewModel(verificator: FailingEmailVerificator(error: .emptyEmail))
        whenRequestingPasswordReset(of: "")
        thenError(is: .emptyEmail)
    }
    
    func test_Shows_loading_when_requesting_password_reset() {
        givenViewModel()
        thenViewModelState(is: .initial)
        whenRequestingPasswordReset(of: "test@test.com")
        thenViewModelState(is: .loading)
    }
    
    func test_Shows_succeed_message_when_password_reset_request_has_sent_mail() {
        
    }
    
    private func givenViewModel(verificator: EmailVerificator = SucceedingEmailVerificator()) {
        viewModel = PasswordResetViewModel(verificator: verificator)
    }
    
    private func whenRequestingPasswordReset(of email: String) {
        viewModel.email = email
        viewModel.requestPasswordReset()
    }
    
    private func thenError(is expected: CredentialsError) {
        XCTAssertEqual(expected, viewModel.error)
    }
    
    private func thenViewModelState(is expected: PasswordResetViewModel.PasswordResetState) {
        XCTAssertEqual(expected, viewModel.state)
    }
    
    private var viewModel: PasswordResetViewModel!
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

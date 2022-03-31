//
//  PasswordResetRequestViewModel_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 04/11/2021.
//

import XCTest
@testable import easyselling

class PasswordResetRequestViewModel_Specs: XCTestCase {

    func test_Shows_error_if_mail_is_not_valid() async {
        givenViewModel(verificator: FailingEmailVerificator(error: .emptyEmail))
        await whenRequestingPasswordReset(of: "")
        thenError(is: .emptyEmail)
    }

    func test_Shows_succeed_message_when_password_reset_request_has_sent_mail() async {
        givenViewModel()
        XCTAssertEqual("An email has been sent to you to reset your password", viewModel.resetRequestSuccessfullySent)
        await whenRequestingPasswordReset(of: "test@test.com")
        thenViewModelState(is: .requestSent)
    }

    func test_Shows_alert_if_something_went_wrong_with_password_reset_request() async {
        givenViewModel(firebaseAuthProvider: FailingFirebaseAuthProvider(error: APICallerError.notFound))
        await whenRequestingPasswordReset(of: "test@test.com")
        XCTAssertEqual(.notFound, viewModel.alert)
        thenViewModelState(is: .initial)
    }

    private func givenViewModel(verificator: EmailVerificator = SucceedingEmailVerificator(),
                                firebaseAuthProvider: FirebaseAuthProvider = SucceedingFirebaseAuthProvider()) {
        viewModel = PasswordResetRequestViewModel(verificator: verificator, firebaseAuthProvider: firebaseAuthProvider)
    }

    private func whenRequestingPasswordReset(of email: String) async {
        viewModel.email = email
        await viewModel.requestPasswordReset()
    }

    private func thenError(is expected: CredentialsError?) {
        XCTAssertEqual(expected, viewModel.error)
    }

    private func thenViewModelState(is expected: PasswordResetRequestViewModel.PasswordResetState) {
        XCTAssertEqual(expected, viewModel.state)
    }

    private var viewModel: PasswordResetRequestViewModel!
}

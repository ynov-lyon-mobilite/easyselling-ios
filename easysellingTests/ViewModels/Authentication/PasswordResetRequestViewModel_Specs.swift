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

    // need to find a way to test error nil during asynchronous process
//    func test_Unshows_error_if_user_has_pressed_reset_again() async {
//        var verificator: EmailVerificator = FailingEmailVerificator(error: .emptyEmail)
//        givenViewModel(verificator: verificator)
//        await whenRequestingPasswordReset(of: "")
//        thenError(is: .emptyEmail)
//        verificator = SucceedingEmailVerificator()
//        await whenRequestingPasswordReset(of: "")
//        thenError(is: nil)
//    }
    
    // need to find a way to test loading state during asynchronous process
    func test_Shows_loading_when_requesting_password_reset() async {

        givenViewModel()
        thenViewModelState(is: .initial)
        let predicate = NSPredicate(block: { _, _ -> Bool in
            return self.viewModel.state == .loading
            })
        let publishExpectation = XCTNSPredicateExpectation(predicate: predicate, object: .none)
        await whenRequestingPasswordReset(of: "test@test.com")
        XCTWaiter().wait(for: [publishExpectation], timeout: 5)
    }
    
    func test_Shows_succeed_message_when_password_reset_request_has_sent_mail() async {
        givenViewModel()
        XCTAssertEqual("An email has been sent to you to reset your password", viewModel.resetRequestSuccessfullySent)
        await whenRequestingPasswordReset(of: "test@test.com")
        thenViewModelState(is: .requestSent)
    }
    
    func test_Shows_alert_if_something_went_wrong_with_password_reset_request() async {
        givenViewModel(passwordRequester: FailingPasswordResetRequester(withError: 404))
        await whenRequestingPasswordReset(of: "test@test.com")
        XCTAssertEqual(.notFound, viewModel.alert)
        thenViewModelState(is: .initial)
    }
    
    private func givenViewModel(verificator: EmailVerificator = SucceedingEmailVerificator(),
                                passwordRequester: PasswordResetRequester = SucceedingPasswordResetRequester()) {
        viewModel = PasswordResetRequestViewModel(verificator: verificator,
                                           passwordRequester: passwordRequester)
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

extension XCTestCase {
    /// Creates an expectation for monitoring the given condition.
    /// - Parameters:
    ///   - condition: The condition to evaluate to be `true`.
    ///   - description: A string to display in the test log for this expectation, to help diagnose failures.
    /// - Returns: The expectation for matching the condition.
    func expectation(for condition: @autoclosure @escaping () -> Bool, description: String = "") -> XCTestExpectation {
        let predicate = NSPredicate { _, _ in
            return condition()
        }

        return XCTNSPredicateExpectation(predicate: predicate, object: nil)
    }
}

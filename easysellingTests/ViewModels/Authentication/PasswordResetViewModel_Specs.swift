//
//  PasswordResetViewModel_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 12/11/2021.
//

import XCTest
@testable import easyselling

class PasswordResetViewModel_Specs: XCTestCase {
    func test_Shows_error_when_new_password_is_empty() async {
        givenViewModel(withToken: "", passwordVerificator: FailingPasswordVerificator(withError: CredentialsError.emptyPassword))
        viewModel.newPassword = ""
        viewModel.newPasswordConfirmation = "passwordConfirmation"
        await whenResetingPassword()
        thenViewModelState(is: .error)
        thenError(is: "Empty password")
    }
    
    func test_Shows_error_when_new_password_confirmation_is_empty() async {
        givenViewModel(withToken: "", passwordVerificator: FailingPasswordVerificator(withError: CredentialsError.emptyPasswordConfirmation))
        viewModel.newPassword = "password"
        viewModel.newPasswordConfirmation = ""
        await whenResetingPassword()
        thenViewModelState(is: .error)
        thenError(is: "Empty password confirmation")
    }
    
    func test_Shows_error_when_new_password_and_confirmation_mismatch() async {
        givenViewModel(withToken: "", passwordVerificator: FailingPasswordVerificator(withError: CredentialsError.wrongPassword))
        viewModel.newPassword = "password"
        viewModel.newPasswordConfirmation = "password"
        await whenResetingPassword()
        thenViewModelState(is: .error)
        thenError(is: "Passwords are differents")
    }
    
    private func givenViewModel(
        withToken token: String,
        passwordVerificator: PasswordVerificator = SucceedingPasswordVerificator(),
        firebaseAuthProvider: FirebaseAuthProvider = SucceedingFirebaseAuthProvider()
    ) {
        viewModel = PasswordResetViewModel(
            token: token,
            preparator: DefaultPasswordResetPreparator(verificator: passwordVerificator),
            firebaseAuthProvider: firebaseAuthProvider,
            onPasswordReset: { self.didResetPassword = true })
    }
    
    private func whenResetingPassword() async {
        await viewModel.resetPassword()
    }

    private func whenDidResetPassword() async {
        await viewModel.resetPassword()
    }
    
    private func thenAlert(is expected: String) {
        XCTAssertEqual(expected, viewModel.alert?.errorDescription)
    }
    
    private func thenAlertIsShown() {
        XCTAssertTrue(viewModel.showAlert)
    }
    
    private func thenError(is expected: String) {
        XCTAssertEqual(expected, viewModel.error?.errorDescription)
    }
    
    private func thenViewModelState(is expected: PasswordResetViewModel.PasswordResetViewModelState) {
        XCTAssertEqual(expected, viewModel.state)
    }
    
    private var viewModel: PasswordResetViewModel!
    private var didResetPassword: Bool = false
}

//
//  PasswordResetViewModel_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 12/11/2021.
//

import XCTest
@testable import easyselling

class PasswordResetViewModel_Specs: XCTestCase {
    
    func test_Leaves_when_password_reset_succeed() async {
        givenViewModel(withToken: "goodTokenToResetPassword", passwordReseter: SucceedingPasswordReseter())
        await whenResetingPassword()
        XCTAssertTrue(didResetPassword)
    }
    
    func test_Shows_alert_when_password_reset_failed() async {
        givenViewModel(withToken: "", passwordReseter: FailingPasswordReseter(withError: APICallerError.notFound))
        await whenResetingPassword()
        thenAlert(is: "Impossible de trouver ce que vous cherchez")
        thenAlertIsShown()
        XCTAssertFalse(didResetPassword)
    }
    
    func test_Shows_error_when_new_password_is_empty() async {
        givenViewModel(withToken: "", passwordVerificator: FailingPasswordVerificator(withError: CredentialsError.emptyPassword), passwordReseter: SucceedingPasswordReseter())
        viewModel.newPassword = ""
        viewModel.newPasswordConfirmation = "passwordConfirmation"
        await whenResetingPassword()
        thenErrorIsShown()
        thenError(is: "Le mot de passe est vide")
    }
    
    func test_Shows_error_when_new_password_confirmation_is_empty() async {
        givenViewModel(withToken: "", passwordVerificator: FailingPasswordVerificator(withError: CredentialsError.emptyPasswordConfirmation), passwordReseter: SucceedingPasswordReseter())
        viewModel.newPassword = "password"
        viewModel.newPasswordConfirmation = ""
        await whenResetingPassword()
        thenErrorIsShown()
        thenError(is: "La confirmation du mot de passe est vide")
    }
    
    func test_Shows_error_when_new_password_and_confirmation_mismatch() async {
        givenViewModel(withToken: "", passwordVerificator: FailingPasswordVerificator(withError: CredentialsError.wrongPassword), passwordReseter: SucceedingPasswordReseter())
        viewModel.newPassword = "password"
        viewModel.newPasswordConfirmation = "password"
        await whenResetingPassword()
        thenErrorIsShown()
        thenError(is: "Les mots de passes sont différents")
    }
    
    private func givenViewModel(withToken token: String, passwordVerificator: PasswordVerificator = SucceedingPasswordVerificator(), passwordReseter: PasswordReseter) {
        viewModel = PasswordResetViewModel(token: token, passwordVerificator: passwordVerificator, passwordReseter: passwordReseter, onPasswordReset: { self.didResetPassword = true })
    }
    
    private func whenResetingPassword() async {
        await viewModel.resetPassword()
    }
    
    private func thenAlert(is expected: String) {
        XCTAssertEqual(expected, viewModel.alert?.errorDescription)
    }
    
    private func thenAlertIsShown() {
        XCTAssertTrue(viewModel.showAlert)
    }
    
    private func thenErrorIsShown() {
        XCTAssertTrue(viewModel.showError)
    }
    
    private func thenError(is expected: String) {
        XCTAssertEqual(expected, viewModel.error?.errorDescription)
    }
    
    private var viewModel: PasswordResetViewModel!
    private var didResetPassword: Bool = false
}

class SucceedingPasswordReseter: PasswordReseter {
    
    func resetPassword(with passwordResetInformations: PasswordResetDTO) async throws {
        return
    }
}

class FailingPasswordReseter: PasswordReseter {
    
    init(withError error: APICallerError) {
        self.error = error
    }
    
    private let error: APICallerError
    
    func resetPassword(with passwordResetInformations: PasswordResetDTO) async throws {
        throw error
    }
}

class FailingPasswordVerificator: PasswordVerificator {
    
    init(withError error: CredentialsError) {
        self.error = error
    }
    
    private let error: CredentialsError
    
    func verify(password: String, passwordConfirmation: String) throws -> PasswordResetDTO {
        throw error
    }
}

class SucceedingPasswordVerificator: PasswordVerificator {
    func verify(password: String, passwordConfirmation: String) throws -> PasswordResetDTO {
        PasswordResetDTO(password: password, token: "")
    }
}

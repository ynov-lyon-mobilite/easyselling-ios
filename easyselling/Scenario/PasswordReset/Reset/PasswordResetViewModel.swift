//
//  PasswordResetViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 12/11/2021.
//

import Foundation

class PasswordResetViewModel: ObservableObject {
    
    init(token: String,
         passwordVerificator: PasswordVerificator = DefaultPasswordVerificator(),
         passwordReseter: PasswordReseter = DefaultPasswordReseter(),
         onPasswordReset: @escaping Action) {
        self.token = token
        self.passwordVerificator = passwordVerificator
        self.passwordReseter = passwordReseter
        self.onPasswordReset = onPasswordReset
    }
    
    private var token: String
    private var passwordVerificator: PasswordVerificator
    private var passwordReseter: PasswordReseter
    private var onPasswordReset: Action
    
    @Published var error: CredentialsError?
    @Published var alert: APICallerError?
    @Published var showAlert: Bool = false
    @Published var showError: Bool = false
    @Published var newPassword: String = ""
    @Published var newPasswordConfirmation: String = ""
    
    func resetPassword() async {
        do {
            var passwordResetDto: PasswordResetDTO = try passwordVerificator.verify(password: newPassword, passwordConfirmation: newPasswordConfirmation)
            passwordResetDto.token = token
            try await passwordReseter.resetPassword(with: passwordResetDto)
            self.onPasswordReset()
        } catch(let error) {
            if let error = error as? CredentialsError {
                self.setError(with: error)
                self.showError = true
            }
            if let error = error as? APICallerError {
                self.alert = error
                self.showAlert = true
            }
        }
    }
    
    private func setError(with error: CredentialsError) {
        self.error = error
    }
}

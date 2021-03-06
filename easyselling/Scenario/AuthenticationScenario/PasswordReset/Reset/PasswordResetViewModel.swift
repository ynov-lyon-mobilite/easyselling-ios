//
//  PasswordResetViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 12/11/2021.
//

import Foundation
import SwiftUI

class PasswordResetViewModel: ObservableObject {
    private let token: String
    private let preparator: DefaultPasswordResetPreparator
    private let firebaseAuthProvider: FirebaseAuthProvider
    private let onPasswordReset: Action

    @Published var error: CredentialsError?
    @Published var alert: APICallerError?
    @Published var showAlert: Bool = false
    @Published var newPassword: String = ""
    @Published var newPasswordConfirmation: String = ""
    @Published var state: PasswordResetViewModelState = .initial

    init(token: String,
         preparator: DefaultPasswordResetPreparator = DefaultPasswordResetPreparator(),
         firebaseAuthProvider: FirebaseAuthProvider = DefaultFirebaseAuthProvider(),
         onPasswordReset: @escaping Action) {
        self.token = token
        self.preparator = preparator
        self.firebaseAuthProvider = firebaseAuthProvider
        self.onPasswordReset = onPasswordReset
    }

    @MainActor
    func resetPassword() async {
        error = nil
        if state == .resetSuccessfull {
            self.onPasswordReset()
        } else {
            do {
                let passwordResetDto = try preparator.prepare(newPassword, passwordConfirmation: newPasswordConfirmation)
                try await firebaseAuthProvider.resetPassword(withCode: token, newPassword: passwordResetDto.password)
                state = .resetSuccessfull
            } catch(let error) {
                if let error = error as? CredentialsError {
                    self.setError(with: error)
                }
                if let error = error as? APICallerError {
                    self.alert = error
                    self.showAlert = true
                }
                state = .error
            }
        }
    }

    private func setError(with error: CredentialsError) {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.error = error
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.error = nil
                }
            }
        }
    }

    enum PasswordResetViewModelState: Equatable {
        case initial
        case resetSuccessfull
        case error
    }
}

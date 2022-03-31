//
//  UserAuthenticationViewModel.swift
//  easyselling
//
//  Created by Maxence on 20/10/2021.
//

import Foundation
import SwiftUI

final class UserAuthenticationViewModel: ObservableObject {
    let firebaseAuthProvider: FirebaseAuthProvider

    let navigateToAccountCreation: Action
    private let onUserLogged: Action
    let navigateToPasswordReset: Action

    @Published var email: String = ""
    @Published var password: String = ""

    @Published var showAlert = false
    @Published var error: CredentialsError?
    @Published var alert: APICallerError?

    init(
        firebaseAuthProvider: FirebaseAuthProvider = DefaultFirebaseAuthProvider(),
        navigateToAccountCreation: @escaping Action,
        navigateToPasswordReset: @escaping Action,
        onUserLogged: @escaping Action) {
            self.navigateToAccountCreation = navigateToAccountCreation
            self.navigateToPasswordReset = navigateToPasswordReset
            self.onUserLogged = onUserLogged
            self.firebaseAuthProvider = firebaseAuthProvider
        }

    @MainActor func login() async {
        do {
            try verifyInformations()
            try await firebaseAuthProvider.signInWithPassword(mail: email, password: password)
            self.onUserLogged()
        } catch(let error) {
            if let credentialError = error as? CredentialsError {
                self.setError(with: credentialError)
            } else if let apiCallerError = error as? APICallerError {
                self.alert = apiCallerError
                showAlert = true
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

    private func verifyInformations() throws {
        if email.isEmpty { throw CredentialsError.emptyEmail }
        if password.isEmpty { throw CredentialsError.emptyPassword }
    }
}

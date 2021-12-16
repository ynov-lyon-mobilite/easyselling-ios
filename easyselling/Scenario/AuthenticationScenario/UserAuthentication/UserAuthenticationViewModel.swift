//
//  UserAuthenticationViewModel.swift
//  easyselling
//
//  Created by Maxence on 20/10/2021.
//

import Foundation
import SwiftUI

final class UserAuthenticationViewModel: ObservableObject {
    private var tokenManager: TokenManager
    private let userAuthenticator: UserAuthenticatior

    let navigateToAccountCreation: Action
    private let onUserLogged: Action
    let navigateToPasswordReset: Action

    @Published var email: String = ""
    @Published var password: String = ""

    @Published var showAlert = false
    @Published var error: CredentialsError?
    @Published var alert: APICallerError?

    init(
        userAuthenticator: UserAuthenticatior = DefaultUserAuthenticator(),
        tokenManager: TokenManager = DefaultTokenManager.shared,
        navigateToAccountCreation: @escaping Action,
        navigateToPasswordReset: @escaping Action,
        onUserLogged: @escaping Action) {
            self.userAuthenticator = userAuthenticator
            self.tokenManager = tokenManager
            self.navigateToAccountCreation = navigateToAccountCreation
            self.navigateToPasswordReset = navigateToPasswordReset
            self.onUserLogged = onUserLogged
        }

    @MainActor func login() async {
        do {
            try verifyInformations()
            let token = try await userAuthenticator.login(mail: email, password: password)
            tokenManager.accessToken = token.accessToken
            tokenManager.refreshToken = token.refreshToken
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
        self.error = error
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            self.error = nil
        }
    }

    private func verifyInformations() throws {
        if email.isEmpty { throw CredentialsError.emptyEmail }
        if password.isEmpty { throw CredentialsError.emptyPassword }
    }
}

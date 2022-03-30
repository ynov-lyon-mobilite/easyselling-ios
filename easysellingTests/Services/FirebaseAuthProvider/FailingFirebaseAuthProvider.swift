//
//  FailingFirebaseAuthProvider.swift
//  easysellingTests
//
//  Created by Maxence on 31/03/2022.
//

import Foundation
@testable import easyselling

final class FailingFirebaseAuthProvider: FirebaseAuthProvider {
    let error: Error
    let isAuthenticated: Bool = false

    init(error: Error) {
        self.error = error
    }

    func signInWithPassword(mail: String, password: String) async throws {
        throw error
    }

    func logout() throws {
        throw error
    }

    func getAccessToken() async -> String? {
        return nil
    }

    func requestResetPasswordLink(email: String) async throws {
        throw error
    }

    func resetPassword(withCode code: String, newPassword password: String) async throws {
        throw error
    }
}

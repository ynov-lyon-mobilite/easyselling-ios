//
//  SucceedingFirebaseAuthProvider.swift
//  easysellingTests
//
//  Created by Maxence on 31/03/2022.
//

import Foundation
@testable import easyselling

final class SucceedingFirebaseAuthProvider: FirebaseAuthProvider {
    let isAuthenticated: Bool

    init(isAuthenticated: Bool = false) {
        self.isAuthenticated = isAuthenticated
    }

    func signInWithPassword(mail: String, password: String) async throws {}

    func logout() throws {}

    func getAccessToken() async -> String? {
        if !isAuthenticated {
            return nil
        }

        return "MY_ACCESS_TOKEN"
    }

    func requestResetPasswordLink(email: String) async throws {}

    func resetPassword(withCode code: String, newPassword password: String) async throws {}
}

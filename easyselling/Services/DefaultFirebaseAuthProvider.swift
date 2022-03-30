//
//  DefaultFirebaseAuthProvider.swift
//  easyselling
//
//  Created by Maxence on 30/03/2022.
//

import Foundation
import FirebaseAuth

protocol FirebaseAuthProvider {
    var isAuthenticated: Bool { get }
    func signInWithPassword(mail: String, password: String) async throws
    func logout() throws
    func getAccessToken() async -> String?
    func requestResetPasswordLink(email: String) async throws
    func resetPassword(withCode code: String, newPassword password: String) async throws
}

final class DefaultFirebaseAuthProvider: FirebaseAuthProvider {
    private let auth = Auth.auth()

    var isAuthenticated: Bool {
        auth.currentUser != nil
    }

    func signInWithPassword(mail: String, password: String) async throws {
        try await auth.signIn(withEmail: mail, password: password)
    }

    func logout() throws {
        try auth.signOut()
    }

    func getAccessToken() async -> String? {
        try? await auth.currentUser?.getIDToken()
    }

    func requestResetPasswordLink(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }

    func resetPassword(withCode code: String, newPassword password: String) async throws {
        try await auth.confirmPasswordReset(withCode: code, newPassword: password)
    }
}

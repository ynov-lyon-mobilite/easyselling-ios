//
//  PasswordResetViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 04/11/2021.
//

import Foundation
import SwiftUI

class PasswordResetRequestViewModel: ObservableObject {
    private let verificator: EmailVerificator
    private let firebaseAuthProvider: FirebaseAuthProvider

    @Published var email: String = ""
    @Published var error: CredentialsError?
    @Published var alert: APICallerError?
    @Published var state: PasswordResetState = .initial
    var resetRequestSuccessfullySent: String = L10n.PasswordReset.mailSentSuccessfully

    init(verificator: EmailVerificator = DefaultEmailVerificator(),
         firebaseAuthProvider: FirebaseAuthProvider = DefaultFirebaseAuthProvider()) {
        self.verificator = verificator
        self.self.firebaseAuthProvider = firebaseAuthProvider
    }

    @MainActor
    func requestPasswordReset() async {
        error = nil
        state = .loading
        do {
            _ = try verificator.verify(email)
            try await firebaseAuthProvider.requestResetPasswordLink(email: email)
            state = .requestSent
        } catch(let error) {
            state = .initial
            if let error = error as? CredentialsError {
                self.setError(with: error)
            }
            if let error = error as? APICallerError {
                self.alert = error
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

    enum PasswordResetState: Equatable {
        case initial
        case loading
        case requestSent
    }
}

struct EmailDTO: Encodable {
    var email: String
}

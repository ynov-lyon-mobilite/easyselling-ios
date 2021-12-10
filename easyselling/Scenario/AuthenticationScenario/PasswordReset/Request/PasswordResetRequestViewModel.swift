//
//  PasswordResetViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 04/11/2021.
//

import Foundation

class PasswordResetRequestViewModel: ObservableObject {

    init(verificator: EmailVerificator = DefaultEmailVerificator(), passwordRequester: PasswordResetRequester = DefaultPasswordResetRequester()) {
        self.verificator = verificator
        self.passwordRequester = passwordRequester
    }

    private let verificator: EmailVerificator
    private let passwordRequester: PasswordResetRequester
    @Published var email: String = ""
    @Published var error: CredentialsError?
    @Published var alert: APICallerError?
    @Published var state: PasswordResetState = .initial
    var resetRequestSuccessfullySent: String = L10n.PasswordReset.mailSentSuccessfully

    @MainActor
    func requestPasswordReset() async {
        error = nil
        state = .loading
        do {
            _ = try verificator.verify(email)
            try await passwordRequester.askForPasswordReset(of: email)
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
        self.error = error
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

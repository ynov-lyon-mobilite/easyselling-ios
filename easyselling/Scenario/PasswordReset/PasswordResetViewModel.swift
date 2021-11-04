//
//  PasswordResetViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 04/11/2021.
//

import Foundation

class PasswordResetViewModel: ObservableObject {
    
    init(verificator: EmailVerificator = DefaultEmailVerificator()) {
        self.verificator = verificator
    }
    
    private let verificator: EmailVerificator
    @Published var email: String = ""
    @Published var error: CredentialsError?
    @Published var state: PasswordResetState = .initial
    
    func requestPasswordReset() {
        state = .loading
        do {
            _ = try verificator.verify(email)
        } catch(let error) {
            if let error = error as? CredentialsError {
                self.setError(with: error)
            }
        }
    }
    
    private func setError(with error: CredentialsError) {
        self.error = error
    }
    
    enum PasswordResetState: Equatable {
        case initial
        case loading
    }
}

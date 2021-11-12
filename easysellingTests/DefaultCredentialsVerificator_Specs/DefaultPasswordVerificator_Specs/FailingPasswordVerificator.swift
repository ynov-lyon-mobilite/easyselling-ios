//
//  FailingPasswordVerificator.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 12/11/2021.
//

@testable import easyselling

class FailingPasswordVerificator: PasswordVerificator {
    
    init(withError error: CredentialsError) {
        self.error = error
    }
    
    private let error: CredentialsError
    
    func verify(password: String, passwordConfirmation: String) throws -> PasswordResetDTO {
        throw error
    }
}

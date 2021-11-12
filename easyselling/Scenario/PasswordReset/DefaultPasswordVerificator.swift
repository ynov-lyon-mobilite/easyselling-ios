//
//  DefaultPasswordVerificator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 12/11/2021.
//

import Foundation

protocol PasswordVerificator {
    func verify(password: String, passwordConfirmation: String) throws -> PasswordResetDTO
}

class DefaultPasswordVerificator: PasswordVerificator {
    
    func verify(password: String, passwordConfirmation: String) throws -> PasswordResetDTO {
        
        guard !password.isEmpty else {
            throw CredentialsError.emptyPassword
        }
        
        guard !passwordConfirmation.isEmpty else {
            throw CredentialsError.emptyPasswordConfirmation
        }
        
        guard password == passwordConfirmation else {
            throw CredentialsError.wrongPassword
        }
        
        return PasswordResetDTO(password: password, token: "")
    }
}

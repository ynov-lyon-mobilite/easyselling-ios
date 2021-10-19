//
//  InformationsVerificator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation

protocol InformationsVerificator {
    func verify(email: String, password: String, passwordConfirmation: String) throws -> AccountCreationInformations
}

class DefaultInformationsVerificator: InformationsVerificator {
    
    func verify(email: String, password: String, passwordConfirmation: String) throws -> AccountCreationInformations {
        
        guard !password.isEmpty else {
            throw AccountCreationError.emptyPassword
        }
        
        guard !passwordConfirmation.isEmpty else {
            throw AccountCreationError.emptyPasswordConfirmation
        }
        
        guard password == passwordConfirmation else {
            throw AccountCreationError.wrongPassword
        }
        
        guard !email.isEmpty else {
            throw AccountCreationError.emptyEmail
        }
        
        guard self.verifyContent(of: email) else {
            throw AccountCreationError.wrongEmail
        }
        
        return AccountCreationInformations(email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
    
    private func verifyContent(of mail: String) -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let range = NSRange(location: 0, length: mail.utf16.count)
        
        guard let regex = try? NSRegularExpression(pattern: emailPattern),
              regex.firstMatch(in: mail, options: [], range: range) != nil else {
                  return false
              }
        return true
    }
}

enum AccountCreationError: LocalizedError, Equatable {
    case wrongEmail
    case emptyEmail
    case wrongPassword
    case emptyPassword
    case emptyPasswordConfirmation
    case unknow
    
    var errorDescription: String? {
        description
    }
    
    private var description: String {
        switch self {
        case .wrongEmail: return "L'addresse email est incorrect"
        case .emptyEmail: return "L'addresse email est vide"
        case .wrongPassword: return "Les mots de passes sont différents"
        case .emptyPassword: return "Le mot de passe est vide"
        case .emptyPasswordConfirmation: return "La confirmation du mot de passe est vide"
        case .unknow: return "Une erreur est survenue"
        }
    }
}

struct AccountCreationInformations: Equatable, Encodable {
    var email: String
    var password: String
    var passwordConfirmation: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
    }
}

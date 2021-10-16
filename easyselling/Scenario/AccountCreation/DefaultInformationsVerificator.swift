//
//  InformationsVerificator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation

protocol InformationsVerificator {
    func verify(email: String, password: String, passwordConfirmation: String) -> Result<AccountCreationInformations, AccountCreationError>?
}

class DefaultInformationsVerificator: InformationsVerificator {
    
    func verify(email: String, password: String, passwordConfirmation: String) -> Result<AccountCreationInformations, AccountCreationError>? {
        
        guard !password.isEmpty else {
            return .failure(.emptyPassword)
        }
        
        guard !passwordConfirmation.isEmpty else {
            return .failure(.emptyPasswordConfirmation)
        }
        
        guard password == passwordConfirmation else {
            return .failure(.wrongPassword)
        }
        
        guard !email.isEmpty else {
            return .failure(.emptyEmail)
        }
        
        guard self.verifyContent(of: email) else {
            return .failure(.wrongEmail)
        }
        
        return .success(AccountCreationInformations(email: email, password: password, passwordConfirmation: passwordConfirmation))
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

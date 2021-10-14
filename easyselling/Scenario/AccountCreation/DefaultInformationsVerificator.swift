//
//  InformationsVerificator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation

protocol InformationsVerificator {
    func verify(email: String, password: String, passwordConfirmation: String, onVerified: @escaping (Result<AccountCreationInformations, AccountCreationError>) -> Void)
}

class DefaultInformationsVerificator: InformationsVerificator {
    
    func verify(email: String, password: String, passwordConfirmation: String, onVerified: @escaping (Result<AccountCreationInformations, AccountCreationError>) -> Void) {
        
        guard password != "" else {
            onVerified(.failure(.emptyPassword))
            return
        }
        
        guard passwordConfirmation != "" else {
            onVerified(.failure(.emptyPasswordConfirmation))
            return
        }
        
        guard password == passwordConfirmation else {
            onVerified(.failure(.wrongPassword))
            return
        }
        
        guard email != "" else {
            onVerified(.failure(.emptyEmail))
            return
        }
        
        self.verifyContent(of: email, onChecked: {
            onVerified(.failure(.wrongEmail))
        })
        
        onVerified(.success(AccountCreationInformations(email: email, password: password, passwordConfirmation: passwordConfirmation)))
    }
    
    private func verifyContent(of mail: String, onChecked: @escaping () -> Void) {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let range = NSRange(location: 0, length: mail.utf16.count)
        
        guard let regex = try? NSRegularExpression(pattern: emailPattern),
              regex.firstMatch(in: mail, options: [], range: range) != nil else {
                  
                  onChecked()
                  return
              }
    }
}

enum AccountCreationError: LocalizedError {
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

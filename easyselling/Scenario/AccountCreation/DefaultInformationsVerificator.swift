//
//  InformationsVerificator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation

protocol InformationsVerificator {
    func verify(_ informations: AccountCreationInformations, onVerified: @escaping (Result<Void, AccountCreationError>) -> Void)
}

class DefaultInformationsVerificator: InformationsVerificator {
    
    func verify(_ informations: AccountCreationInformations, onVerified: @escaping (Result<Void, AccountCreationError>) -> Void) {
        
        guard informations.password != "" else {
            onVerified(.failure(.emptyPassword))
            return
        }
        
        guard informations.passwordConfirmation != "" else {
            onVerified(.failure(.emptyPasswordConfirmation))
            return
        }
        
        guard informations.password == informations.passwordConfirmation else {
            onVerified(.failure(.wrongPassword))
            return
        }
        
        guard informations.email != "" else {
            onVerified(.failure(.emptyEmail))
            return
        }
        
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let range = NSRange(location: 0, length: informations.email.utf16.count)
        
        guard let regex = try? NSRegularExpression(pattern: emailPattern),
              regex.firstMatch(in: informations.email, options: [], range: range) != nil else {
                  
            onVerified(.failure(.wrongEmail))
            return
        }
        
        onVerified(.success(()))
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

struct AccountCreationInformations {
    var email: String
    var password: String
    var passwordConfirmation: String
}

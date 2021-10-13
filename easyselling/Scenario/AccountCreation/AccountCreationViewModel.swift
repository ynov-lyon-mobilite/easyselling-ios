//
//  AccountCreationViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation

class AccountCreationViewModel: ObservableObject {
    
}

class InformationsVerificator {
    
    func verify(_ informations: AccountCreationInformations, onVerified: @escaping (Result<Bool, AccountCreationError>) -> Void) {
        guard informations.password == informations.passwordConfirmation else {
            onVerified(.failure(.wrongPassword))
            return
        }
        onVerified(.success(true))
    }
}

enum AccountCreationError: LocalizedError {
    case wrongPassword
    
    var errorDescription: String? {
        description
    }
    
    private var description: String {
        switch self {
        case .wrongPassword: return "Les mots de passes sont différents"
        }
    }
}

struct AccountCreationInformations {
    var email: String
    var password: String
    var passwordConfirmation: String
}

//
//  DefaultCredentialsPreparator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 20/11/2021.
//

import Foundation

protocol CredentialsPreparator {
    func prepare(email: String, password: String, passwordConfirmation: String) throws -> AccountCreationInformations
}

class DefaultCredentialsPreparator: CredentialsPreparator {
    
    init(verificator: CredentialsVerificator = DefaultCredentialsVerificator(), transformator: CredentialsTransformator = DefaultCredentialsTransformator()) {
        
        self.verificator = verificator
        self.transformator = transformator
    }
    
    private var verificator: CredentialsVerificator
    private var transformator: CredentialsTransformator
    
    func prepare(email: String, password: String, passwordConfirmation: String) throws -> AccountCreationInformations {
        try verificator.verify(email: email, password: password, passwordConfirmation: passwordConfirmation)
        return transformator.transform(email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
}

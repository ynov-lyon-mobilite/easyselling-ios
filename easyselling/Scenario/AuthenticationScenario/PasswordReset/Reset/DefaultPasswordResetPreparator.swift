//
//  DefaultPasswordResetPreparator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 17/11/2021.
//

import Foundation

class DefaultPasswordResetPreparator {
    
    init(verificator: PasswordVerificator = DefaultPasswordVerificator(),
         transformator: DefaultPasswordResetTransformator = DefaultPasswordResetTransformator()) {
        self.verificator = verificator
        self.transformator = transformator
    }
    
    private let verificator: PasswordVerificator
    private let transformator: DefaultPasswordResetTransformator
    
    func prepare(_ password: String, passwordConfirmation: String) throws -> PasswordResetDTO {
        try verificator.verify(password: password, passwordConfirmation: passwordConfirmation)
        return transformator.transformAsDTO(password)
    }
}

//
//  SucceedingCredentialsPreparator.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 20/11/2021.
//

@testable import easyselling

class SucceedingCredentialsPreparator: CredentialsPreparator {
            
    func prepare(email: String, password: String, passwordConfirmation: String) throws -> AccountCreationInformations {
        return AccountCreationInformations(email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
}

//
//  FailingCredentialsPreparator.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 20/11/2021.
//

@testable import easyselling

class FailingCredentialsPreparator: CredentialsPreparator {
    
    init(withError error: CredentialsError) {
        self.error = error
    }
    
    private let error: CredentialsError
    
    func prepare(email: String, password: String, passwordConfirmation: String) throws -> AccountCreationInformations {
        throw error
    }
}

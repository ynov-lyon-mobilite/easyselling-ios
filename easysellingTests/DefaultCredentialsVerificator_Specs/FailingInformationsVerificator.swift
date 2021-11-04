//
//  FailingInformationsVerificator.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 16/10/2021.
//

import Foundation
@testable import easyselling

class FailingInformationsVerificator: CredentialsVerificator {
    
    init(error: CredentialsError) {
        self.error = error
    }
    
    private var error: CredentialsError
    
    func verify(email: String, password: String, passwordConfirmation: String) throws -> AccountCreationInformations {
        throw error
    }
}

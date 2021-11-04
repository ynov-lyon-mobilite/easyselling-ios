//
//  SucceedingInformationsVerificator.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 16/10/2021.
//

import Foundation
@testable import easyselling

class SucceedingInformationsVerificator: CredentialsVerificator {
    
    private(set) var accountCreationInformation: AccountCreationInformations?
    
    func verify(email: String, password: String, passwordConfirmation: String) throws -> AccountCreationInformations {
        self.accountCreationInformation = AccountCreationInformations(email: email, password: password, passwordConfirmation: passwordConfirmation)
        return accountCreationInformation!
    }
}

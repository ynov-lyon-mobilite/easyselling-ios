//
//  FailingInformationsVerificator.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 16/10/2021.
//

import Foundation
@testable import easyselling

class FailingInformationsVerificator: InformationsVerificator {
    
    init(error: AccountCreationError) {
        self.error = error
    }
    
    private var error: AccountCreationError
    
    func verify(email: String, password: String, passwordConfirmation: String) -> Result<AccountCreationInformations, AccountCreationError>? {
        return .failure(error)
    }
}

//
//  NeverFinishingInformationsVerificator.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 16/10/2021.
//

import Foundation
@testable import easyselling

class NeverFinishingInformationsVerificator: InformationsVerificator {
        
    func verify(email: String, password: String, passwordConfirmation: String) -> Result<AccountCreationInformations, AccountCreationError>? {
        return nil
    }
}

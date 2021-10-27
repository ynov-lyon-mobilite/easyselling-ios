//
//  FailingAccountCreator.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 16/10/2021.
//

import Foundation
import Combine
@testable import easyselling

class FailingAccountCreator: AccountCreator {    
    private var error: APICallerError

    init(error: APICallerError) {
        self.error = error
    }
    
    func createAccount(informations: AccountCreationInformations) async throws {
        throw error
    }
}

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
    
    init(error: APICallerError) {
        self.error = error
    }
    
    private var error: APICallerError
    
    func createAccount(informations: AccountCreationInformations) async throws {
        throw APICallerError.from(statusCode: error.rawValue)
    }
}

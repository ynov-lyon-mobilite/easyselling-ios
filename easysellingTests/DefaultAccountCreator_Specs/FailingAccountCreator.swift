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
    
    init(error: HTTPError) {
        self.error = error
    }
    
    private var error: HTTPError
    
    func createAccount(informations: AccountCreationInformations) async throws {
        throw HTTPError.from(statusCode: error.rawValue)
    }
}

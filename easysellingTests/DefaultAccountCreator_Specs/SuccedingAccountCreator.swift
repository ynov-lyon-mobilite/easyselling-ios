//
//  SuccedingAccountCreator.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 16/10/2021.
//

import Foundation
import Combine
@testable import easyselling

class SucceedingAccountCreator: AccountCreator {
    
    func createAccount(informations: AccountCreationInformations) -> VoidResult {
        return Just(())
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
    }
}

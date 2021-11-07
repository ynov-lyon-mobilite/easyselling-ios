//
//  FailingEmailVerificator.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 07/11/2021.
//

@testable import easyselling

class FailingEmailVerificator: EmailVerificator {
    
    init(error: CredentialsError) {
        self.error = error
    }
    
    private let error: CredentialsError
    
    func verify(_ email: String) throws -> String {
        throw error
    }
}

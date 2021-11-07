//
//  FailingPasswordResetRequester.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 07/11/2021.
//

@testable import easyselling

class FailingPasswordResetRequester: PasswordResetRequester {
    
    init(withError error: Int) {
        self.error = error
    }
    
    private let error: Int
    
    func askForPasswordReset(of email: String) async throws {
        throw APICallerError.from(statusCode: error)
    }
}

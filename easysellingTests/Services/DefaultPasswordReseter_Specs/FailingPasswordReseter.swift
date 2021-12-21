//
//  FailingPasswordReseter.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 12/11/2021.
//

@testable import easyselling

class FailingPasswordReseter: PasswordReseter {
    
    init(withError error: APICallerError) {
        self.error = error
    }
    
    private let error: APICallerError
    
    func resetPassword(with passwordResetInformations: PasswordResetDTO) async throws {
        throw error
    }
}

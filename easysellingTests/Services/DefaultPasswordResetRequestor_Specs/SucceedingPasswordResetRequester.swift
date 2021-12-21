//
//  SucceedingPasswordResetRequester.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 07/11/2021.
//

@testable import easyselling

class SucceedingPasswordResetRequester: PasswordResetRequester {
    
    func askForPasswordReset(of email: String) async throws {}
}

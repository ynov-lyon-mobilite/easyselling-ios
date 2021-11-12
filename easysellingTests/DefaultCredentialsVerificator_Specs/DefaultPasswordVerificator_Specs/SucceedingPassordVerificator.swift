//
//  SucceedingPassordVerificator.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 12/11/2021.
//

@testable import easyselling

class SucceedingPasswordVerificator: PasswordVerificator {
    func verify(password: String, passwordConfirmation: String) throws -> PasswordResetDTO {
        PasswordResetDTO(password: password, token: "")
    }
}

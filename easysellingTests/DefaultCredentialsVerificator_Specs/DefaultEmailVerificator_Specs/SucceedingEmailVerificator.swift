//
//  SucceedingEmailVerificator.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 07/11/2021.
//

@testable import easyselling

class SucceedingEmailVerificator: EmailVerificator {
    
    func verify(_ email: String) throws -> String {
        email
    }
}

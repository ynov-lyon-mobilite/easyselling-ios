//
//  DefaultEmailVerificator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 04/11/2021.
//

import Foundation

protocol EmailVerificator {
    func verify(_ email: String) throws -> String
}

class DefaultEmailVerificator: EmailVerificator {
    
    func verify(_ email: String) throws -> String {
        guard !email.isEmpty else {
            throw CredentialsError.emptyEmail
        }
        
        guard self.verifyContent(of: email) else {
            throw CredentialsError.wrongEmail
        }
        
        return email
    }
    
    private func verifyContent(of mail: String) -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let range = NSRange(location: 0, length: mail.utf16.count)
        
        guard let regex = try? NSRegularExpression(pattern: emailPattern),
              regex.firstMatch(in: mail, options: [], range: range) != nil else {
                  return false
              }
        return true
    }
}

//
//  InformationsVerificator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation

protocol CredentialsVerificator {
    func verify(email: String, password: String, passwordConfirmation: String) throws
}

class DefaultCredentialsVerificator: CredentialsVerificator {

    init(emailVerificator: EmailVerificator = DefaultEmailVerificator(), passwordVerificator: PasswordVerificator = DefaultPasswordVerificator()) {
        self.emailVerificator = emailVerificator
        self.passwordVerificator = passwordVerificator
    }

    private var emailVerificator: EmailVerificator
    private var passwordVerificator: PasswordVerificator

    func verify(email: String, password: String, passwordConfirmation: String) throws {

        try passwordVerificator.verify(password: password, passwordConfirmation: passwordConfirmation)
        try emailVerificator.verify(email)
        return
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

enum CredentialsError: LocalizedError, Equatable {
    case wrongEmail
    case emptyEmail
    case wrongPassword
    case emptyPassword
    case emptyPasswordConfirmation
    case unknow

    var errorDescription: String? {
        switch self {
        case .wrongEmail: return L10n.CredentialsError.invalidEmail
        case .emptyEmail: return L10n.CredentialsError.emptyEmail
        case .wrongPassword: return L10n.CredentialsError.wrongPasswords
        case .emptyPassword: return L10n.CredentialsError.emptyPassword
        case .emptyPasswordConfirmation: return L10n.CredentialsError.emptyPasswordConfirmation
        case .unknow: return L10n.Error.occured
        }
    }
}

struct AccountCreationInformations: Equatable, Encodable {
    var email: String
    var password: String
    var passwordConfirmation: String

    enum CodingKeys: String, CodingKey {
        case email
        case password
    }
}

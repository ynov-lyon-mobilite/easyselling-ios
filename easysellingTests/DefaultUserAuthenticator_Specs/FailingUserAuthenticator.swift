//
//  FailingUserAuthenticator.swift
//  easysellingTests
//
//  Created by Maxence on 20/10/2021.
//

import Foundation
@testable import easyselling

final class FailingUserAuthenticator: UserAuthenticatior {
    init(error: APICallerError) {
        self.error = error
    }
    
    private var error: APICallerError

    func login(mail: String, password: String) async throws -> Token {
        throw error
    }
}

//
//  FailingTokenRefreshor.swift
//  easysellingTests
//
//  Created by Maxence on 02/11/2021.
//

import Foundation
@testable import easyselling

class FailingTokenRefreshor: TokenRefreshor {
    init(error: APICallerError) {
        self.error = error
    }
    
    private var error: APICallerError

    func refresh(refreshToken: String) async throws -> Token {
        throw error
    }
}

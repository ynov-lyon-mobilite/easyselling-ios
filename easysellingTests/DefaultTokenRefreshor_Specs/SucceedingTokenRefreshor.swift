//
//  SucceedingTokenRefreshor.swift
//  easysellingTests
//
//  Created by Maxence on 02/11/2021.
//

import Foundation
@testable import easyselling

class SucceedingTokenRefreshor: TokenRefreshor {
    let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func refresh(refreshToken: String) async throws -> Token {
        let refreshToken = "wcA0WsKCAIA8ywcGt8jlsWKn-1MGKyGZcembTHsWfgmoQ3aTUnsPHCU_MIveDsr5"
        
        return Token(accessToken: accessToken, refreshToken: refreshToken)
    }
}

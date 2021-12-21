//
//  SucceedingUserAuthenticator.swift
//  easysellingTests
//
//  Created by Maxence on 20/10/2021.
//

import Foundation
@testable import easyselling

final class SucceedingUserAuthenticator: UserAuthenticatior {
    func login(mail: String, password: String) async throws -> Token {
        let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImRkMzEwYTUzLWZmZTYtNDY5YS05NWRmLWRlNGE4OGE1ZTU5ZiIsImlhdCI6MTYzNDY3NjQ1OSwiZXhwIjoxNjM0Njc3MzU5LCJpc3MiOiJkaXJlY3R1cyJ9.lsMJA8Dvbu3muCZ77gYPDqdIYELrWlJsPh4e0A6tJxI"
        let refreshToken = "wcA0WsKCAIA8ywcGt8jlsWKn-1MGKyGZcembTHsWfgmoQ3aTUnsPHCU_MIveDsr5"
        
        return Token(accessToken: accessToken, refreshToken: refreshToken)
    }
}

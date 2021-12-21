//
//  FakeTokenManager.swift
//  easysellingTests
//
//  Created by Maxence on 02/11/2021.
//

import Foundation
@testable import easyselling

class FakeTokenManager: TokenManager {
    var refreshToken: String?
    var accessToken: String?
    let accessTokenIsExpired: Bool
    
    init(accessTokenIsExpired: Bool = false, accessToken: String? = nil, refreshToken: String? = nil) {
        self.accessTokenIsExpired = accessTokenIsExpired
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    func setTokens(_ token: Token) {
        accessToken = token.accessToken
        refreshToken = token.refreshToken
    }
}

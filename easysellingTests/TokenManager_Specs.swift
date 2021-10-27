//
//  TokenManager_Specs.swift
//  easysellingTests
//
//  Created by Maxence on 20/10/2021.
//

import Foundation
import XCTest
import KeychainSwift
@testable import easyselling

final class TokenManager_Specs: XCTestCase {
    
    func test_Saves_tokens_in_keychain() {
        givenTokenManager()
        whenSetTokensWithTokenManager(accessToken: "JWTToken", refreshToken: "RefreshToken")
        thenTokenAre(accessToken: "JWTToken", refreshToken: "RefreshToken")
    }
    
    func test_Removes_tokens_from_keychain() {
        givenTokenManager()
        whenSetTokensWithTokenManager(accessToken: nil, refreshToken: nil)
        thenTokenAre(accessToken: nil, refreshToken: nil)
    }
    
    private func givenTokenManager() {
        tokenManager = TokenManager(keychain: keychain)
    }
    
    private func whenSetTokensWithTokenManager(accessToken: String?, refreshToken: String?) {
        tokenManager.accessToken = accessToken
        tokenManager.refreshToken = refreshToken
    }
    
    private func thenTokenAre(accessToken expectedAccessToken: String?, refreshToken expectedRefreshToken: String?) {
        let accessToken = keychain.get(KeychainSwift.KeychainKeys.accessToken)
        let refreshToken = keychain.get(KeychainSwift.KeychainKeys.refreshToken)
        
        XCTAssertEqual(expectedAccessToken, accessToken)
        XCTAssertEqual(expectedRefreshToken, refreshToken)
    }
    
    private let keychain: KeychainSwift = .unitTestsKeychain
    private var tokenManager: TokenManager!
}

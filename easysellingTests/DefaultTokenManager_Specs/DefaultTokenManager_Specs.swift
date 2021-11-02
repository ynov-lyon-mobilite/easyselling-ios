//
//  DefaultTokenManager_Specs.swift
//  easysellingTests
//
//  Created by Maxence on 20/10/2021.
//

import Foundation
import XCTest
import KeychainSwift
@testable import easyselling

final class DefaultTokenManager_Specs: XCTestCase {
    
    func test_Saves_tokens_in_keychain() {
        givenTokenManager()
        whenSaveToken(accessToken: "JWTToken", refreshToken: "RefreshToken")
        thenTokenAre(accessToken: "JWTToken", refreshToken: "RefreshToken")
    }
    
    func test_Removes_tokens_from_keychain() {
        givenTokenManager()
        whenSaveToken(accessToken: nil, refreshToken: nil)
        thenTokenAre(accessToken: nil, refreshToken: nil)
    }
    
    func test_Verifies_not_expired_access_token() {
        givenTokenManager()
        whenSaveToken(accessToken: updatedAccessToken, refreshToken: nil)
        
        XCTAssertTrue(!tokenManager.accessTokenIsExpired)
    }
    
    func test_Verifies_expired_access_token() {
        givenTokenManager()
        whenSaveToken(accessToken: outdatedAccessToken, refreshToken: nil)
        
        XCTAssertTrue(tokenManager.accessTokenIsExpired)
    }
    
    private func givenTokenManager() {
        tokenManager = DefaultTokenManager(keychain: keychain)
    }
    
    private func whenSaveToken(accessToken: String?, refreshToken: String?) {
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
    
    private let outdatedAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPbmxpbmUgSldUIEJ1aWxkZXIiLCJpYXQiOjE2MzU4MzMwOTAsImV4cCI6MTYwNDI5NzA5MCwiYXVkIjoid3d3LmV4YW1wbGUuY29tIiwic3ViIjoianJvY2tldEBleGFtcGxlLmNvbSJ9.E3KPcWx5_rzlyThc7s-EKFQPLu6xkXv7TX5RbpIHINY"
    
    private var updatedAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPbmxpbmUgSldUIEJ1aWxkZXIiLCJpYXQiOjI1NTA5Nzc4NjIsImV4cCI6MjU1MDk3Nzg2MiwiYXVkIjoid3d3LmV4YW1wbGUuY29tIiwic3ViIjoianJvY2tldEBleGFtcGxlLmNvbSJ9.ENKI9xGTd8ytjIcR-WU4ew1OjosULqgzznYcwneY4_s"
}

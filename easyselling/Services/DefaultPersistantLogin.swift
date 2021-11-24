//
//  DefaultPersistantLogin.swift
//  easyselling
//
//  Created by Théo Tanchoux on 24/11/2021.
//

import Foundation

protocol PersistantLogin {
    func getAccessToken() async throws -> String
}

class DefaultPersistantLogin : PersistantLogin {

    private var tokenManager: TokenManager
    private let tokenRefreshor: TokenRefreshor

    init(tokenManager: TokenManager = DefaultTokenManager.shared,
         tokenRefreshor: TokenRefreshor = DefaultTokenRefreshor()) {
        self.tokenManager = tokenManager
        self.tokenRefreshor = tokenRefreshor
    }

    func getAccessToken() async throws -> String {
        
        return ""
    }
}

//
//  TokenManager.swift
//  easyselling
//
//  Created by Maxence on 20/10/2021.
//

import Foundation
import KeychainSwift

final class TokenManager: ObservableObject {
    static let shared = TokenManager()
    private let keychain: KeychainSwift
    
    init(keychain: KeychainSwift = .productionKeychain) {
        self.keychain = keychain
    }
    
    var refreshToken: String? {
        didSet {
            if let token = self.refreshToken {
                keychain.set(token, forKey: .refreshToken)
            } else {
                keychain.delete(.refreshToken)
            }
        }
    }
    
    var accessToken: String? {
        didSet {
            if let token = self.accessToken {
                keychain.set(token, forKey: .accessToken)
            } else {
                keychain.delete(.accessToken)
            }
        }
    }
}

//
//  DefaultTokenManager.swift
//  easyselling
//
//  Created by Maxence on 20/10/2021.
//

import Foundation
import KeychainSwift
import JWTDecode

protocol TokenManager {
    var accessTokenIsExpired: Bool { get }
    var refreshToken: String? { get set }
    var accessToken: String? { get set }

    func setTokens(_ token: Token)
}

final class DefaultTokenManager: TokenManager, ObservableObject {
    static let shared = DefaultTokenManager()
    private let keychain: KeychainSwift

    init(keychain: KeychainSwift = .productionKeychain) {
        self.keychain = keychain
    }

    var refreshToken: String? {
        get {
            keychain.get(.refreshToken)
        }
        set {
            if let token = newValue {
                keychain.set(token, forKey: .refreshToken)
            } else {
                keychain.delete(.refreshToken)
            }
        }
    }

    var accessToken: String? {
        get {
            keychain.get(.accessToken)
        }
        set {
            if let token = newValue {
                keychain.set(token, forKey: .accessToken)
            } else {
                keychain.delete(.accessToken)
            }
        }
    }

    private var decodedToken: JWT? {
        guard let token = accessToken,
              let decoded = try? decode(jwt: token) else { return nil }

        return decoded
    }

    func setTokens(_ token: Token) {
        accessToken = token.accessToken
        refreshToken = token.refreshToken
    }

    var accessTokenIsExpired: Bool {
        return decodedToken?.expired ?? true
    }

    func flush() {
        keychain.clear()
    }
}

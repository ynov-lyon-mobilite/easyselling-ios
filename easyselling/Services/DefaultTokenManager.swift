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
}

final class DefaultTokenManager: TokenManager, ObservableObject {
    static let shared = DefaultTokenManager()
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

    private var decodedToken: JWT? {
        guard let token = accessToken,
              let decoded = try? decode(jwt: token) else { return nil }

        return decoded
    }

    var accessTokenIsExpired: Bool {
        return decodedToken?.expired ?? true
    }
}

//
//  KeychainSwift+Extensions.swift
//  easyselling
//
//  Created by Maxence on 20/10/2021.
//

import KeychainSwift

extension KeychainSwift {
    func set(_ value: String, forKey key: KeychainKeys) {
        self.set(value, forKey: key.rawValue)
    }

    func delete(_ key: KeychainKeys) {
        self.delete(key.rawValue)
    }

    func get(_ key: KeychainKeys) -> String? {
        return self.get(key.rawValue)
    }

    enum KeychainKeys: String {
        case refreshToken = "easyselling-refresh-bearer-token"
        case accessToken = "easyselling-bearer-token"
    }

    static var unitTestsKeychain = KeychainSwift(keyPrefix: "easyselling_tests")
    static var productionKeychain = KeychainSwift(keyPrefix: "easyselling_tests")
}

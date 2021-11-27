//
//  ProfileViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 26/11/2021.
//

import Foundation

class ProfileViewModel: ObservableObject {

    init(tokenManager: TokenManager = DefaultTokenManager(), onLogout: @escaping Action) {
        self.tokenManager = tokenManager
        self.onLogout = onLogout
    }

    private var tokenManager: TokenManager
    private var onLogout: Action

    func logout() {
        tokenManager.accessToken = nil
        tokenManager.refreshToken = nil
        onLogout()
    }
}

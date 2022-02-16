//
//  ProfileViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 26/11/2021.
//

import Foundation

class ProfileViewModel: ObservableObject {

    init(tokenManager: TokenManager = DefaultTokenManager(), onLogout: @escaping Action, isNavigatingToSettingsMenu: @escaping Action) {
        self.tokenManager = tokenManager
        self.onLogout = onLogout
        self.isNavigatingToSettingsMenu = isNavigatingToSettingsMenu
    }

    private var tokenManager: TokenManager
    private var onLogout: Action
    private var isNavigatingToSettingsMenu: Action

    func logout() {
        tokenManager.accessToken = nil
        tokenManager.refreshToken = nil
        onLogout()
    }

    func navigatesToSettingsMenu() {
        isNavigatingToSettingsMenu()
    }
}

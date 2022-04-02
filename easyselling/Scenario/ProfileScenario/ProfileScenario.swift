//
//  ProfileScenario.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 26/11/2021.
//

import Foundation

class ProfileScenario {

    init(navigator: ProfileNavigator, onLogout: @escaping Action) {
        self.navigator = navigator
        self.onLogout = onLogout
    }

    private var onLogout: Action

    func begin() {
        navigator.navigatesToProfile(onLogout: onLogout, onNavigateToSettingsMenu: navigatesToSettingsMenu)
    }

    private func navigatesBackToAuthentication() {
//        navigator.navigatesBackToAuthentication()
    }

    private func navigatesToSettingsMenu() {
        navigator.navigatesToSettingsMenu()
    }

    private var navigator: ProfileNavigator
}

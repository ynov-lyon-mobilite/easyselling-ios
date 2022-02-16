//
//  ProfileScenario.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 26/11/2021.
//

import Foundation

class ProfileScenario {

    init(navigator: ProfileNavigator) {
        self.navigator = navigator
    }

    func begin() {
        navigator.navigatesToProfile(onLogout: navigatesBackToAuthentication, onNavigateToSettingsMenu: navigatesToSettingsMenu)
    }

    private func navigatesBackToAuthentication() {
        navigator.navigatesBackToAuthentication()
    }

    private func navigatesToSettingsMenu() {
        navigator.navigatesToSettingsMenu()
    }

    private var navigator: ProfileNavigator
}

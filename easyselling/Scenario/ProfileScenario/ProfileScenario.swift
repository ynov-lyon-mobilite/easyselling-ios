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
        navigator.navigatesToProfile(onLogout: navigatesBackToAuthentication)
    }

    private func navigatesBackToAuthentication() {
        navigator.navigatesBackToAuthentication()
    }

    private var navigator: ProfileNavigator
}

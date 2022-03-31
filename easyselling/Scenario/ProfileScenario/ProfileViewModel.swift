//
//  ProfileViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 26/11/2021.
//

import Foundation

class ProfileViewModel: ObservableObject {
    let firebaseAuthProvider: FirebaseAuthProvider
    private let onLogout: Action
    private let isNavigatingToSettingsMenu: Action

    init(firebaseAuthProvider: FirebaseAuthProvider = DefaultFirebaseAuthProvider(),
         onLogout: @escaping Action, isNavigatingToSettingsMenu: @escaping Action) {
        self.onLogout = onLogout
        self.isNavigatingToSettingsMenu = isNavigatingToSettingsMenu
        self.firebaseAuthProvider = firebaseAuthProvider
    }

    func logout() {
        try? firebaseAuthProvider.logout()
        onLogout()
    }

    func navigatesToSettingsMenu() {
        isNavigatingToSettingsMenu()
    }
}

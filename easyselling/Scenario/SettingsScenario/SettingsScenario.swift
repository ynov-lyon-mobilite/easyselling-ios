//
//  SettingsScenario.swift
//  easyselling
//
//  Created by Lucas Barthélémy on 15/12/2021.
//

import Foundation
import SwiftUI

class SettingsScenario {

    init(navigator: SettingsNavigator) {
        self.navigator = navigator
    }

    private var navigator: SettingsNavigator

    func begin() {
        navigator.navigatesToSettingsView()
    }
}

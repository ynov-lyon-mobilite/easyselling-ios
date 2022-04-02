//
//  ProfileScenarioViewInstatiator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 21/03/2022.
//

import Foundation
import SwiftUI

struct ProfileScenarioViewInstantiator: UIViewControllerRepresentable {

    init(onLogout: @escaping Action) {
        self.onLogout = onLogout
    }

    private var onLogout: Action

    func makeUIViewController(context: Context) -> UINavigationController {
        return profileScenario(onLogout: onLogout)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }

    private func profileScenario(onLogout: @escaping Action) -> UINavigationController {
           let navigationController = UINavigationController()

           let profileNavigator = DefaultProfileNavigator(navigationController: navigationController, window: UIWindow())
        let profileScenario = ProfileScenario(navigator: profileNavigator, onLogout: onLogout)
           profileScenario.begin()

           return navigationController
       }
}

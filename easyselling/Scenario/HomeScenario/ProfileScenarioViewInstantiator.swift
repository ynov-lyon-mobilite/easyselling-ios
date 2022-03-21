//
//  ProfileScenarioViewInstatiator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 21/03/2022.
//

import Foundation
import SwiftUI

struct ProfileScenarioViewInstantiator: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UINavigationController {
        return profileScenario()
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }

    private func profileScenario() -> UINavigationController {
           let navigationController = UINavigationController()

           let profileNavigator = DefaultProfileNavigator(navigationController: navigationController, window: UIWindow())
           let profileScenario = ProfileScenario(navigator: profileNavigator)
           profileScenario.begin()

           return navigationController
       }
}

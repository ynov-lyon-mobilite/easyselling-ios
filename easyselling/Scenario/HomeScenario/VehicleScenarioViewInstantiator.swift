//
//  VehicleScenarioViewInstantiator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 21/03/2022.
//

import Foundation
import SwiftUI

struct VehicleScenarioViewInstantiator: UIViewControllerRepresentable {

    init(window: UIWindow?) {
        self.window = window
    }

    private var window: UIWindow?

    func makeUIViewController(context: Context) -> UINavigationController {
        return vehicleScenario()
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }

    private func vehicleScenario() -> UINavigationController {
        let navigationController = UINavigationController()
        let vehicleNavigator = DefaultVehicleNavigator(window: window)
        let vehicleScenario = VehicleScenario(navigator: vehicleNavigator)
        vehicleScenario.begin()

        return navigationController
    }
}

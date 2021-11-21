//
//  VehicleScenario.swift
//  easyselling
//
//  Created by Valentin Mont School on 18/10/2021.
//
import UIKit
import SwiftUI
class VehicleScenario {

    init(navigator: VehicleNavigator) {
        self.navigator = navigator
    }

    private var navigator: VehicleNavigator

    func begin() {
        navigator.navigatesToHomeView(onVehicleCreationOpen: navigatesToVehicleCreation,
									  onVehicleUpdateOpen: navigatesToVehicleUpdate,
                                      onNavigateToProfile: navigatesToProfile)
    }

    private func navigatesToVehicleCreation() {
        navigator.navigatesToVehicleCreation(onFinish: goingBackToHomeView)
    }
    
    private func goingBackToHomeView() {
        navigator.goingBackToHomeView()
	}
    
    func navigatesToVehicleUpdate(vehicle: Vehicle) {
        navigator.navigatesToVehicleUpdate(onFinish: goingBackToHomeView, vehicle: vehicle)
    }

}

protocol VehicleNavigator {
    
    func navigatesToHomeView(onVehicleCreationOpen: @escaping Action, onVehicleUpdateOpen: @escaping OnUpdatingVehicle)
    func navigatesToVehicleCreation(onFinish: @escaping () async -> Void)
    func goingBackToHomeView()
    func navigatesToVehicleUpdate(onFinish: @escaping () async -> Void, vehicle: Vehicle)
}

class DefaultVehicleNavigator: VehicleNavigator {
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    private func navigatesToProfile() {
        navigator.navigatesToProfile()
    }
    func goingBackToHomeView() {
        DispatchQueue.main.async {
            self.navigationController.dismiss(animated: true)
        }
    }
}

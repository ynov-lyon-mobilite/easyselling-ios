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
    
    private func goingBackToHomeView() async {
        await navigator.goingBackToHomeView()
	}
    func navigatesToVehicleUpdate(vehicule: Vehicle) {
        navigator.navigatesToVehicleUpdate(onFinish: goingBackToHomeView, vehicule: vehicule)
    }

}

protocol VehicleNavigator {
    
    func navigatesToHomeView(onVehicleCreationOpen: @escaping Action, onVehicleUpdateOpen: @escaping OnUpdatingVehicle)
    func navigatesToVehicleCreation(onFinish: @escaping () async -> Void)
    func goingBackToHomeView() async
    func navigatesToVehicleUpdate(onFinish: @escaping Action, vehicule: Vehicle)
}

class DefaultVehicleNavigator: VehicleNavigator {
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    private func navigatesToProfile() {
        navigator.navigatesToProfile()
    }

    private func goingBackToHomeView() {
        navigator.goingBackToHomeView()
    }
}

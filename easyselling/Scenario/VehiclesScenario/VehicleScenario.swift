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

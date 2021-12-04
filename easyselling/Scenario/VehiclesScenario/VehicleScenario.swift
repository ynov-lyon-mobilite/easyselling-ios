//
//  VehicleScenario.swift
//  easyselling
//
//  Created by Valentin Mont School on 18/10/2021.
//
import UIKit

class VehicleScenario {

    init(navigator: VehicleNavigator) {
        self.navigator = navigator
    }

    private var navigator: VehicleNavigator

    func begin() {
        navigator.navigatesToHomeView(onVehicleCreationOpen: navigatesToVehicleCreation,
									  onVehicleUpdateOpen: navigatesToVehicleUpdate,
                                      onNavigateToProfile: navigatesToProfile,
										onNavigatingToInvoices: navigatesToInvoices)
    }

    private func navigatesToVehicleCreation() {
        navigator.navigatesToVehicleCreation(onFinish: goingBackToHomeView)
    }

    private func goingBackToHomeView() {
        navigator.goingBackToHomeView()
	}

    private func navigatesToProfile() {
        navigator.navigatesToProfile()
    }

    private func navigatesToInvoices(ofVehicleId vehicleId: String) {
        navigator.navigatesToInvoices(ofVehicleId: vehicleId)
    }

    func navigatesToVehicleUpdate(vehicle: Vehicle, refreshVehicles: @escaping AsyncableAction) {
        navigator.navigatesToVehicleUpdate(onFinish: { [goingBackToHomeView] in
            await refreshVehicles()
            goingBackToHomeView()
        }, vehicle: vehicle)
    }
}

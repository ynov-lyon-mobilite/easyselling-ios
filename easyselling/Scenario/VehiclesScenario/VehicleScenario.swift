//
//  VehicleScenario.swift
//  easyselling
//
//  Created by Valentin Mont School on 18/10/2021.
//

class VehicleScenario {

    init(navigator: VehicleNavigator) {
        self.navigator = navigator
    }

    private var navigator: VehicleNavigator

    func begin() {
        navigator.navigatesToHomeView(onVehicleUpdateOpen: navigatesToVehicleUpdate,
                                      onNavigateToProfile: navigatesToProfile,
                                      onNavigatingToInvoices: navigatesToInvoices,
                                      onNavigateToSettingsMenu: {})
    }

    private func goingBackToHomeView() {
        navigator.goingBackToHomeView()
	}

    private func navigatesToProfile() {
        navigator.navigatesToProfile()
    }

    private func navigatesToInvoices(vehicle: Vehicle) {
        navigator.navigatesToInvoices(vehicle: vehicle)
    }

    func navigatesToVehicleUpdate(vehicle: Vehicle, refreshVehicles: @escaping AsyncableAction) {
        navigator.navigatesToVehicleUpdate(onFinish: { [goingBackToHomeView] in
            await refreshVehicles()
            goingBackToHomeView()
        }, vehicle: vehicle)
    }
}

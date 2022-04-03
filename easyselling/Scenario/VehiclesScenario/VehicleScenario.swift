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

    func begin(withVehicleActivationId id: String? = nil) {
        navigator.navigatesToHomeView(withActivationId: id,
									  onVehicleUpdateOpen: navigatesToVehicleUpdate,
                                      onNavigatingToInvoices: navigatesToInvoices,
                                      onVehicleShareOpen: navigatesToVehicleShare)
    }

    private func goingBackToHomeView() {
        navigator.goingBackToHomeView()
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

    private func navigatesToVehicleShare(vehicle: Vehicle) {
        navigator.navigatesToVehicleShare(vehicle: vehicle)
    }
}

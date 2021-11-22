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
        navigator.navigatesToHomeView(onVehicleCreationOpen: navigatesToVehicleCreation)
    }

    func navigatesToVehicleCreation() {
        navigator.navigatesToVehicleCreation(onFinish: goingBackToHomeView)
    }

    private func goingBackToHomeView() {
        navigator.goingBackToHomeView()
    }
}

//
//  DefaultVehicleNavigator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/11/2021.
//

import UIKit
import SwiftUI

protocol VehicleNavigator {
    func navigatesToVehicleUpdate(onFinish: @escaping () async -> Void, vehicle: Vehicle)
    func navigatesToHomeView(onVehicleCreationOpen: @escaping Action, onVehicleUpdateOpen: @escaping OnUpdatingVehicle, onNavigateToProfile: @escaping Action)
    func navigatesToVehicleCreation(onFinish: @escaping () async -> Void)
    func navigatesToProfile()
    func goingBackToHomeView()
}

class DefaultVehicleNavigator: VehicleNavigator {

    init(window: UIWindow?) {
        self.window = window
    }

    private var navigationController: UINavigationController = UINavigationController()
    private var window: UIWindow?

    func navigatesToHomeView(onVehicleCreationOpen: @escaping Action, onVehicleUpdateOpen: @escaping OnUpdatingVehicle, onNavigateToProfile: @escaping Action) {
        window?.rootViewController = navigationController

        let vm = MyVehiclesViewModel(isOpenningVehicleCreation: onVehicleCreationOpen, isOpeningVehicleUpdate:  onVehicleUpdateOpen, isNavigatingToProfile: onNavigateToProfile)
        let myVehiclesView = MyVehiclesView(viewModel: vm)
        navigationController.pushViewController(UIHostingController(rootView: myVehiclesView), animated: true)
    }

    func navigatesToVehicleCreation(onFinish: @escaping () async -> Void) {
        let vm = VehicleCreationViewModel(vehicleCreator: DefaultVehicleCreator(), vehicleVerificator: DefaultVehicleInformationsVerificator(), onFinish: onFinish)
        let vehicleCreationView = VehicleCreationView(viewModel: vm)
        navigationController.present(UIHostingController(rootView: vehicleCreationView), animated: true)
    }

    func navigatesToProfile() {
        let navigator = DefaultProfileNavigator(navigationController: navigationController, window: window)
        let scenario = ProfileScenario(navigator: navigator)
        scenario.begin()
    }

    
    func navigatesToVehicleUpdate(onFinish: @escaping () async -> Void, vehicle: Vehicle) {
        let vm = VehicleUpdateViewModel(vehicle: vehicle, onFinish: onFinish, vehicleVerificator: DefaultVehicleInformationsVerificator(), vehicleUpdater: DefaultVehicleUpdater())
        let view = VehicleUpdateView(viewModel: vm)
        navigationController.present(UIHostingController(rootView: view), animated: true)
    }

    func goingBackToHomeView() {
        DispatchQueue.main.async {
            self.navigationController.dismiss(animated: true)
        }
    }
}

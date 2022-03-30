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
    func navigatesToHomeView(onVehicleUpdateOpen: @escaping OnUpdatingVehicle,
                             onNavigatingToInvoices: @escaping (String) -> Void)
    func navigatesToInvoices(ofVehicleId vehicleId: String)
    func navigatesToVehicleCreation(onFinish: @escaping () async -> Void)
    func goingBackToHomeView()
}

class DefaultVehicleNavigator: VehicleNavigator {

    init(window: UIWindow?) {
        self.window = window
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    private var navigationController: UINavigationController = UINavigationController()
    private var window: UIWindow?

    func navigatesToHomeView(onVehicleUpdateOpen: @escaping OnUpdatingVehicle,
                             onNavigatingToInvoices: @escaping (Vehicle) -> Void,
        window?.rootViewController = navigationController

        let vm = MyVehiclesViewModel(isOpeningVehicleUpdate: onVehicleUpdateOpen,
                                     isNavigatingToInvoices: onNavigatingToInvoices)
        let myVehiclesView = MyVehiclesView(viewModel: vm)

        navigationController.pushViewController(UIHostingController(rootView: myVehiclesView), animated: true)
    }

//    func navigatesToVehicleCreation(onFinish: @escaping () async -> Void) {
//        let vm = VehicleCreationViewModel(vehicleCreator: DefaultVehicleCreator(), vehicleVerificator: DefaultVehicleInformationsVerificator(), onFinish: onFinish)
//        let vehicleCreationView = VehicleCreationView(viewModel: vm)
//        navigationController.present(UIHostingController(rootView: vehicleCreationView), animated: true)
//    }

    func navigatesToVehicleUpdate(onFinish: @escaping AsyncableAction, vehicle: Vehicle) {
        let vm = VehicleUpdateViewModel(vehicle: vehicle, onFinish: onFinish)
        let view = VehicleUpdateView(viewModel: vm)
        navigationController.present(UIHostingController(rootView: view), animated: true)
	}

    func navigatesToInvoices(vehicle: Vehicle) {
        let navigator = DefaultInvoicesNavigator(navigationController: navigationController)
        let scenario = InvoicesScenario(navigator: navigator)
        scenario.begin(vehicle: vehicle)
    }

    func navigatesToSettingsMenu() {
        let navigator = DefaultSettingsNavigator(navigationController: navigationController)
        let scenario = SettingsScenario(navigator: navigator)
        scenario.begin()
    }

    func goingBackToHomeView() {
        DispatchQueue.main.async {
            self.navigationController.dismiss(animated: true)
        }
    }
}

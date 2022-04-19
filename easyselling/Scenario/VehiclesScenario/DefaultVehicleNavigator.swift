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
    func navigatesToHomeView(withActivationId id: String?,
                             onVehicleUpdateOpen: @escaping OnUpdatingVehicle,
                             onNavigatingToInvoices: @escaping (Vehicle) -> Void,
                             onVehicleShareOpen: @escaping (Vehicle) -> Void)
    func navigatesToInvoices(vehicle: Vehicle)
    func goingBackToHomeView()
    func navigatesToVehicleShare(vehicle: Vehicle)
}

class DefaultVehicleNavigator: VehicleNavigator {
    private var navigationController: UINavigationController
    private var window: UIWindow?

    init(window: UIWindow?, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }

    func navigatesToHomeView(withActivationId id: String?,
							 onVehicleUpdateOpen: @escaping OnUpdatingVehicle,
                             onNavigatingToInvoices: @escaping (Vehicle) -> Void,
                             onVehicleShareOpen: @escaping (Vehicle) -> Void) {

        let vm = MyVehiclesViewModel(isOpeningVehicleUpdate: onVehicleUpdateOpen,
                                     isNavigatingToInvoices: onNavigatingToInvoices,
                                     isOpeningVehicleShare: onVehicleShareOpen)
        let myVehiclesView = MyVehiclesView(viewModel: vm)

        navigationController.pushViewController(UIHostingController(rootView: myVehiclesView), animated: true)
    }

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

    func navigatesToVehicleShare(vehicle: Vehicle) {
        let vm = VehicleShareViewModel(vehicle: vehicle)
        let view = VehicleShareView(viewModel: vm)
        navigationController.present(UIHostingController(rootView: view), animated: true)
    }

    func goingBackToHomeView() {
        DispatchQueue.main.async {
            self.navigationController.dismiss(animated: true)
        }
    }
}

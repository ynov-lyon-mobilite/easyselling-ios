//
//  DefaultVehicleNavigator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/11/2021.
//

import UIKit
import SwiftUI

protocol VehicleNavigator {

    func navigatesToHomeView(onVehicleCreationOpen: @escaping Action, onNavigateToProfile: @escaping Action)
    func navigatesToVehicleCreation(onFinish: @escaping () async -> Void)
    func navigatesToProfile()
    func goingBackToHomeView()
}

class DefaultVehicleNavigator: VehicleNavigator {

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    private var navigationController: UINavigationController

    func navigatesToHomeView(onVehicleCreationOpen: @escaping Action, onNavigateToProfile: @escaping Action) {
        let vm = MyVehiclesViewModel(isOpenningVehicleCreation: onVehicleCreationOpen, isNavigatingToProfile: onNavigateToProfile)
        let myVehiclesView = MyVehiclesView(viewModel: vm)
        navigationController.pushViewController(UIHostingController(rootView: myVehiclesView), animated: true)
    }

    func navigatesToVehicleCreation(onFinish: @escaping () async -> Void) {
        let vm = VehicleCreationViewModel(vehicleCreator: DefaultVehicleCreator(), vehicleVerificator: DefaultVehicleInformationsVerificator(), onFinish: onFinish)
        let vehicleCreationView = VehicleCreationView(viewModel: vm)
        navigationController.present(UIHostingController(rootView: vehicleCreationView), animated: true)
    }

    func navigatesToProfile() {
        let navigator = DefaultProfileNavigator(navigationController: navigationController)
        let scenario = ProfileScenario(navigator: navigator)
        scenario.begin()
    }

    func goingBackToHomeView() {
        DispatchQueue.main.async {
            self.navigationController.dismiss(animated: true)
        }
    }
}

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
        navigator.navigatesToHomeView(onVehicleCreationOpen: navigatesToVehicleCreation)
    }
    
    func navigatesToVehicleCreation() {
        navigator.navigatesToVehicleCreation(onFinish: goingBackToHomeView)
    }
    
    private func goingBackToHomeView() {
        navigator.goingBackToHomeView()
    }
}

protocol VehicleNavigator {
    
    func navigatesToHomeView(onVehicleCreationOpen: @escaping Action)
    func navigatesToVehicleCreation(onFinish: @escaping Action)
    func goingBackToHomeView()
}

class DefaultVehicleNavigator: VehicleNavigator {
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    private var navigationController: UINavigationController
    
    func navigatesToHomeView(onVehicleCreationOpen: @escaping Action) {
        let vm = MyVehiclesViewModel(isOpenningVehicleCreation: onVehicleCreationOpen)
        let myVehiclesView = MyVehiclesView(viewModel: vm)
        navigationController.pushViewController(UIHostingController(rootView: myVehiclesView), animated: true)
    }
    
    func navigatesToVehicleCreation(onFinish: @escaping Action) {
        let vm = VehicleCreationViewModel(vehicleCreator: VehicleCreator(), vehicleVerificator: VehicleInformationsVerificator(), onFinish: onFinish)
        let vehicleCreationView = VehicleCreationView(viewModel: vm)
        navigationController.present(UIHostingController(rootView: vehicleCreationView), animated: true)
    }
    
    func goingBackToHomeView() {
        DispatchQueue.main.async {
            self.navigationController.dismiss(animated: true)
        }
    }
}

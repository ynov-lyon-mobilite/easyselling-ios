//
//  VehicleScenario.swift
//  easyselling
//
//  Created by Valentin Mont School on 18/10/2021.
//

import UIKit
import SwiftUI

class VehicleScenario {
    
    init(navigator: VehicleCreationNavigator) {
        self.navigator = navigator
    }
    
    private var navigator: VehicleCreationNavigator
    
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

protocol VehicleCreationNavigator {
    
    func navigatesToHomeView(onVehicleCreationOpen: @escaping Action)
    func navigatesToVehicleCreation(onFinish: @escaping Action)
    func goingBackToHomeView()
}

class DefaultVehicleCreationNavigator: VehicleCreationNavigator {
    
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
        let vm = VehicleCreationViewModel(onFinish: onFinish)
        let vehicleCreationView = VehicleCreationView(viewModel: vm)
        navigationController.present(UIHostingController(rootView: vehicleCreationView), animated: true)
    }
    
    func goingBackToHomeView() {
        navigationController.dismiss(animated: true)
    }
}

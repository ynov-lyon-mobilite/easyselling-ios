//
//  DefaultVehicleNavigator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/11/2021.
//

import UIKit
import SwiftUI

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
        let vm = VehicleCreationViewModel(onFinish: onFinish)
        let vehicleCreationView = VehicleCreationView(viewModel: vm)
        navigationController.present(UIHostingController(rootView: vehicleCreationView), animated: true)
    }
    
    func goingBackToHomeView() {
        navigationController.dismiss(animated: true)
    }
}

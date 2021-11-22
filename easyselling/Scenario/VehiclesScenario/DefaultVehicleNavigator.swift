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
    func navigatesToVehicleCreation(onFinish: @escaping () async -> Void)
    func goingBackToHomeView()
}

class DefaultVehicleNavigator: VehicleNavigator {
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    private var navigationController: UINavigationController
    weak var delegate: MyVehiclesDelegate?
    
    func navigatesToHomeView(onVehicleCreationOpen: @escaping Action) {
        let vm = MyVehiclesViewModel(isOpenningVehicleCreation: onVehicleCreationOpen)
        let myVehiclesView = MyVehiclesView(viewModel: vm)
        delegate = vm
        navigationController.pushViewController(UIHostingController(rootView: myVehiclesView), animated: true)
    }
    
    func navigatesToVehicleCreation(onFinish: @escaping () async -> Void) {
        let vm = VehicleCreationViewModel(vehicleCreator: DefaultVehicleCreator(), vehicleVerificator: DefaultVehicleInformationsVerificator(), onFinish: onFinish)
        let vehicleCreationView = VehicleCreationView(viewModel: vm)
        navigationController.present(UIHostingController(rootView: vehicleCreationView), animated: true)
    }
    
    func goingBackToHomeView() {
        DispatchQueue.main.async {
            self.navigationController.dismiss(animated: true)
        }
    }
}

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
    
    private func goingBackToHomeView() async {
        await navigator.goingBackToHomeView()
    }
}

protocol VehicleNavigator {
    
    func navigatesToHomeView(onVehicleCreationOpen: @escaping Action)
    func navigatesToVehicleCreation(onFinish: @escaping () async -> Void)
    func goingBackToHomeView() async
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
        let vm = VehicleCreationViewModel(vehicleCreator: DefaultVehicleCreator(), vehicleVerificator: VehicleInformationsVerificator(), onFinish: onFinish)
        let vehicleCreationView = VehicleCreationView(viewModel: vm)
        navigationController.present(UIHostingController(rootView: vehicleCreationView), animated: true)
    }
    
    func goingBackToHomeView() async {
        await delegate?.updateVehiclesList()
        DispatchQueue.main.async {
            self.navigationController.dismiss(animated: true)
        }
    }
}

//
//  VehicleCreationScenario.swift
//  easyselling
//
//  Created by Valentin Mont School on 18/10/2021.
//

import Foundation
import UIKit
import SwiftUI

class VehicleCreationScenario {
    
    init(navigationController: UINavigationController) {
        let vehicleCreationViewModel = VehicleCreationViewModel()
        let vehicleCreationView = VehicleCreationView(viewModel: vehicleCreationViewModel)
        navigationController.pushViewController(UIHostingController(rootView: vehicleCreationView), animated: true)
    }
}

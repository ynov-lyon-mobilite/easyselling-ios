//
//  VehiculeUpdateViewModel.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 17/11/2021.
//

import Foundation

class VehicleUpdateViewModel: ObservableObject {
    let vehicule: Vehicle
    
    init(vehicule: Vehicle) {
        self.vehicule = vehicule
    }
}

//
//  VehicleUpdateViewModel.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 18/11/2021.
//

import Foundation

class VehicleUpdateViewModel: ObservableObject {
    
    private(set) var vehicle: Vehicle
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
    }
    
}

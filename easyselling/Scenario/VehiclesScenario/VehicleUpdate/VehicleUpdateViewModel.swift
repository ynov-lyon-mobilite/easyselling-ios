//
//  VehicleUpdateViewModel.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 18/11/2021.
//

import Foundation

class VehicleUpdateViewModel: ObservableObject {
    
    private(set) var vehicle: Vehicle
    private(set) var onFinish: () async -> Void
    
    var id: String = ""
    var brand: String = ""
    var model: String = ""
    var license: String = ""
    var type: Vehicle.Category = .car
    var year: String = ""
    
    init(vehicle: Vehicle, onFinish: @escaping () async -> Void) {
        self.vehicle = vehicle
        self.onFinish = onFinish
    }
    
    func delete() async {
        await self.onFinish() 
    }
}

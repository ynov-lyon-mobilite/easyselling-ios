//
//  SucceedingVehicleDeletor.swift
//  easysellingTests
//
//  Created by Lucas Barthélémy on 23/11/2021.
//

@testable import easyselling

class SucceedingVehicleDeletor: VehicleDeletor {
    
    func deleteVehicle(id: String) {
        var index = 0
        for vehicle in vehicles {
            if vehicle.id == id {
                self.vehicles.remove(at: index)
                break
            } else {
                index += 1
            }
        }
    }
}

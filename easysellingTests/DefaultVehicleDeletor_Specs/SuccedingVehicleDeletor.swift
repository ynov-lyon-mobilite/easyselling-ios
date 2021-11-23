//
//  SuccedingVehicleDeletor.swift
//  easysellingTests
//
//  Created by Lucas Barthélémy on 23/11/2021.
//


@testable import easyselling

class SucceedingVehicleDeletor: VehicleDeletor {
    
    init(_ vehicles: [Vehicle]) {
        self.vehicles = vehicles
    }
    
    private var vehicles: [Vehicle]
    
    func deleteVehicle(id: String) /*-> [Vehicle]*/ {
        var index = 0
        for vehicle in vehicles {
            if vehicle.id == id {
                self.vehicles.remove(at: index)
                break
                //return self.vehicles
            } else {
                index += 1
            }
        }
        
        //return self.vehicles
    }
}

//
//  SucceedingVehicleGetter.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 07/12/2021.
//

@testable import easyselling

class SucceedingVehiclesGetter: VehiclesGetter {

    var error: APICallerError?

    init(_ vehicles: [Vehicle]) {
        self.vehicles = vehicles
    }

    private var vehicles: [Vehicle]

    func getVehicles() async -> [Vehicle] {
        return vehicles
    }
}

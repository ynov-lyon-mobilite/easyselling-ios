//
//  SucceedingVehiclesGetter.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 07/12/2021.
//

@testable import easyselling

class SucceedingVehiclesGetter: VehiclesGetter {

    init(_ vehicles: [Vehicle]) {
        self.vehicles = vehicles
    }

    private var vehicles: [Vehicle]

    func getVehicles() async throws -> [Vehicle] {
        return vehicles
    }
}

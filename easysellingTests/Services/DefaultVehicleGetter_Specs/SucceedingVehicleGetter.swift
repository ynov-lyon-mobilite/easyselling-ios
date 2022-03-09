//
//  SuccedingVehicleGetter.swift
//  easysellingTests
//
//  Created by Théo Tanchoux on 09/03/2022.
//

@testable import easyselling

class SucceedingVehicleGetter: VehicleGetter {

    init(_ vehicle: Vehicle) {
        self.vehicle = vehicle
    }
    private var vehicle: Vehicle

    func getVehicle(id: String) async throws -> Vehicle {
        return vehicle
    }
}

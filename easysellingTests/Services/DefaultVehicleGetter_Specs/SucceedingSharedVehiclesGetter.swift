//
//  SuccedingVehicleGetter.swift
//  easysellingTests
//
//  Created by Théo Tanchoux on 09/03/2022.
//

@testable import easyselling

class SucceedingSharedVehiclesGetter: SharedVehiclesGetter {

    init(_ vehicles: [Vehicle]) {
        self.vehicles = vehicles
    }
    private var vehicles: [Vehicle]

    func getSharedVehicles() async throws -> [Vehicle] {
        return vehicles
    }
}

//
//  FailingVehicleGetter.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 07/12/2021.
//

@testable import easyselling

class FailingVehiclesGetter: VehiclesGetter {

    init(withError error: APICallerError) {
        self.error = error
    }

    private var error: APICallerError

    func getVehicles() async throws -> [Vehicle] {
        throw error
    }
}

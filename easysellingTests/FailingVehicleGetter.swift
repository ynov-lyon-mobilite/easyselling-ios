//
//  FailingVehicleGetter.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 07/12/2021.
//

@testable import easyselling

class FailingVehiclesGetter: VehiclesGetter {

    var error: APICallerError?

    init(withError error: APICallerError) {
        self.error = error
    }

    func getVehicles() async -> [Vehicle] {
        return []
    }
}

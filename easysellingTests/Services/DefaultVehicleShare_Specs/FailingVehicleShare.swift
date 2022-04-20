//
//  FailingVehicleShare.swift
//  easyselling
//
//  Created by Théo Tanchoux on 09/03/2022.
//

@testable import easyselling

class FailingVehicleShare: VehicleShare {

    init(withError error: APICallerError) {
        self.error = error
    }

    private var error: APICallerError

    func shareVehicle(id: String, email: String) async throws {
        throw error
    }
}

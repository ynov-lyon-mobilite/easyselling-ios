//
//  FailingVehicleDeletor.swift
//  easysellingTests
//
//  Created by Lucas Barthélémy on 23/11/2021.
//

@testable import easyselling

class FailingVehicleDeletor: VehicleDeletor {

    init(withError error: APICallerError) {
        self.error = error
    }

    private var error: APICallerError

    func deleteVehicle(id: String) async throws {
        throw error
    }
}

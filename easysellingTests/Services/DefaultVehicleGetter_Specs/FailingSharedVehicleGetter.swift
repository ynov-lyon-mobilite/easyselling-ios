//
//  FailingVehicleGetter.swift
//  easysellingTests
//
//  Created by Théo Tanchoux on 09/03/2022.
//

@testable import easyselling

class FailingSharedVehiclesGetter: SharedVehiclesGetter {

    init(withError error: APICallerError) {
        self.error = error
    }

    private var error: APICallerError

    func getSharedVehicles() async throws -> [Vehicle] {
        throw error
    }
}

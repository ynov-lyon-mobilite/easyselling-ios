//
//  FailingVehicleInvoicesGetter.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 05/12/2021.
//

import Foundation
import Combine
@testable import easyselling

class FailingVehicleInvoicesGetter: VehicleInvoicesGetter {

    private var error: APICallerError

    init(withError error: APICallerError) {
        self.error = error
    }

    func getInvoices(ofVehicleId: String) async throws -> [InvoiceCoreData] {
        throw error
    }

}

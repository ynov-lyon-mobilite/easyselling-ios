//
//  SucceedingVehicleInvoiceGetter.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 05/12/2021.
//

import Foundation
import Combine
@testable import easyselling

class SucceedingVehicleInvoicesGetter: VehicleInvoicesGetter {

    private var invoices: [Invoice]

    init(_ invoices: [Invoice]) {
        self.invoices = invoices
    }

    func getInvoices(ofVehicleId: String) async throws -> [Invoice] {
        return invoices
    }

}

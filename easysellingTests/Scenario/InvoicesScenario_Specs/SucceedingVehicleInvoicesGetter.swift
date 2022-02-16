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

    private var invoices: [InvoiceCoreData]

    init(_ invoices: [InvoiceCoreData]) {
        self.invoices = invoices
    }

    func getInvoices(ofVehicleId: String) async throws -> [InvoiceCoreData] {
        return invoices
    }

}

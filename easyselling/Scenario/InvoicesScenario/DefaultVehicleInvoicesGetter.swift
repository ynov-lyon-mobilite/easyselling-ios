//
//  DefaultVehicleInvoicesGetter.swift
//  easyselling
//
//  Created by Corentin Laurencine on 24/11/2021.
//

import Foundation

protocol VehicleInvoicesGetter {
    func getInvoices(ofVehicleId: String) async throws -> [Invoice]
}

class DefaultVehicleInvoicesGetter : VehicleInvoicesGetter {
    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    func getInvoices(ofVehicleId id: String) async throws -> [Invoice] {
        do {
            let urlRequest = try await requestGenerator.generateRequest(endpoint: .invoices,
                                                                        method: .GET,
                                                                        headers: [:],
                                                                        pathKeysValues: ["vehicleId": id],
                                                                        queryParameters: nil)
            let invoices = try await apiCaller.call(urlRequest, decodeType: [Invoice].self)
            mainContext.performAndWait {
                for invoice in invoices {
                    let invoiceCoreData = InvoiceCoreData.fetchRequestById(id: invoice.id)

                    if invoiceCoreData == nil {
                        _ = Invoice.toCoreDataObject(invoice: invoice)
                        if mainContext.hasChanges {
                            try? mainContext.save()
                        }
                    }
                }
            }
            return invoices
        } catch (_) {
            let invoicesCoreData = try? mainContext.fetch(InvoiceCoreData.fetchRequest())
            var invoices: [Invoice] = []

            invoicesCoreData?.forEach { invoice in
                invoices.append(Invoice.fromCoreDataToObject(invoice: invoice))
            }

            return invoices
        }
    }
}

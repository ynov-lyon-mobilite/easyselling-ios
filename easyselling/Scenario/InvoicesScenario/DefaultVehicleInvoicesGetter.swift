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

    func generateRequest() async -> URLRequest? {
        let request: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator()
        let urlRequest = try? await request.generateRequest(endpoint: .invoices, method: .GET, headers: [:], pathKeysValues: [:], queryParameters: [])

        return urlRequest
    }

    func getInvoices(ofVehicleId id: String) async throws -> [Invoice] {
        guard let request = await self.generateRequest() else { return [] }
        do {
            let urlRequest = try await requestGenerator.generateRequest(endpoint: .invoices, method: .GET, headers: [:],
                                                                        pathKeysValues: [:], queryParameters: [FilterQueryParameter(
                                                                            parameterName: "vehicle",
                                                                            type: .EQUAL,
                                                                            value: id)])
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

    private func isDuplicate(id: Int) -> Bool {

        if (((try? mainContext.fetch(Invoice.fetchRequestById(id: Int16(id))))?.count) != nil) {
            return true
        }

        return false
    }
}

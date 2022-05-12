//
//  DefaultVehicleInvoicesGetter.swift
//  easyselling
//
//  Created by Corentin Laurencine on 24/11/2021.
//

import Foundation
import CoreData

protocol VehicleInvoicesGetter {
    func getInvoices(ofVehicleId: String) async throws -> [Invoice]
}

class DefaultVehicleInvoicesGetter : VehicleInvoicesGetter {
    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller
    private var context: NSManagedObjectContext

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(),
         apiCaller: APICaller = DefaultAPICaller(),
         context: NSManagedObjectContext = mainContext) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
        self.context = context
    }

    func getInvoices(ofVehicleId id: String) async throws -> [Invoice] {
        do {
            let urlRequest = try await requestGenerator.generateRequest(endpoint: .invoices,
                                                                        method: .GET,
                                                                        headers: [:],
                                                                        pathKeysValues: ["vehicleId": id],
                                                                        queryParameters: nil)
            let invoices = try await apiCaller.call(urlRequest, decodeType: [Invoice].self)
            context.performAndWait {
                for invoice in invoices {
                    let invoiceCoreData = InvoiceCoreData.fetchRequestById(id: invoice.id)

                    if invoiceCoreData == nil {
                        _ = invoice.toCoreDataObject(in: context)
                        if context.hasChanges {
                            try? context.save()
                        }
                    }
                }
            }
            return invoices
        } catch {
            let invoicesCoreData = try? context.fetch(InvoiceCoreData.fetchRequest())
            var invoices: [Invoice] = []
            invoicesCoreData?.forEach { invoice in
                context.performAndWait {
                    invoices.append(invoice.toObject())
                }
            }

            return invoices
        }
    }
}

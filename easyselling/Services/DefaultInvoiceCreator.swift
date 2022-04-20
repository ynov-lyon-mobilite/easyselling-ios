//
//  DefaultInvoiceCreator.swift
//  easyselling
//
//  Created by Maxence on 14/11/2021.
//

import Foundation
import CoreData

protocol InvoiceCreator {
    func createInvoice(vehicleId: String, invoice: InvoiceDTO) async throws
}

class DefaultInvoiceCreator: InvoiceCreator {
    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller
    private var context: NSManagedObjectContext

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(),
         apiCaller: APICaller = DefaultAPICaller(),
         context: NSManagedObjectContext) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
        self.context = context
    }

    func createInvoice(vehicleId: String, invoice: InvoiceDTO) async throws {
        let urlRequest = try await requestGenerator.generateRequest(
            endpoint: .invoices, method: .POST, body: invoice, headers: [:],
            pathKeysValues: ["vehicleId" : vehicleId], queryParameters: nil)
        let invoice = try await apiCaller.call(urlRequest, decodeType: Invoice.self)

        try context.performAndWait {
            _ = invoice.toCoreDataObject(in: context)
            if context.hasChanges {
                try context.save()
            }
        }
    }
}

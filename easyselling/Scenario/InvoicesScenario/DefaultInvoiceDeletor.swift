//
//  DefaultInvoiceDeletor.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 15/12/2021.
//

import Foundation
import CoreData

protocol InvoiceDeletor {
    func deleteInvoice(id: String) async throws
}

class DefaultInvoiceDeletor: InvoiceDeletor {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(),
         apiCaller: APICaller = DefaultAPICaller(),
         context: NSManagedObjectContext) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
        self.context = context
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller
    private var context: NSManagedObjectContext

    func deleteInvoice(id: String) async throws {
        do {
            let urlRequest = try await requestGenerator.generateRequest(endpoint: .invoiceId, method: .DELETE, headers: [:],
                                                                        pathKeysValues: ["invoiceId" : id], queryParameters: nil)
            try await apiCaller.call(urlRequest)

            try context.performAndWait {
                if let invoice = InvoiceCoreData.fetchRequestById(id: id) {
                    context.delete(invoice)
                    if context.hasChanges {
                        try context.save()
                    }
                }
            }
        } catch (let error) {
            throw error
        }
    }
}

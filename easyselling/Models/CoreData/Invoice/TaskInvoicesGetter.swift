//
//  TaskInvoicesGetter.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 26/01/2022.
//

import Foundation
import CoreData
import SwiftUI

class TaskInvoicesGetter: DefaultAPICaller, TaskAPI {

    func generateRequest() async -> URLRequest? {
        let request: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator()
        let urlRequest = try? await request.generateRequest(endpoint: .invoices, method: .GET, headers: [:], pathKeysValues: [:], queryParameters: [])

        return urlRequest
    }

    func parseJSONToCoreDataObject() async {
        guard let request = await self.generateRequest() else { return }

        do {
            let invoices = try await self.call(request, decodeType: [InvoiceResponse].self)

            for invoice in invoices {
                mainContext.performAndWait {
                    let entity = Invoice(context: mainContext)
                    entity.id = Int16(invoice.id)
                    entity.vehicle = invoice.vehicle
                    entity.file = invoice.file
                    entity.dateCreated = invoice.dateCreated
                    entity.dateUpdated = invoice.dateUpdated

                    if mainContext.hasChanges {
                        try? mainContext.save()
                    }
                }
            }
        } catch (let error) {
            print(error)
        }
    }
}

struct InvoiceResponse: Codable {
    var id : Int
    var vehicle : String
    var file : String
    var dateCreated : String
    var dateUpdated : String?
}

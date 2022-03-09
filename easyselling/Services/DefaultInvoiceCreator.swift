//
//  DefaultInvoiceCreator.swift
//  easyselling
//
//  Created by Maxence on 14/11/2021.
//

import Foundation

protocol InvoiceCreator {
    func createInvoice(vehicleId: String, invoice: InvoiceDTO) async throws
}

class DefaultInvoiceCreator: InvoiceCreator {
    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    func createInvoice(vehicleId: String, invoice: InvoiceDTO) async throws {
        let urlRequest = try await requestGenerator.generateRequest(endpoint: .invoices, method: .POST, body: invoice, headers: [:], pathKeysValues: ["vehicleId" : vehicleId], queryParameters: nil)
        try await apiCaller.call(urlRequest)
    }
}

//
//  DefaultInvoiceDeletor.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 15/12/2021.
//

import Foundation

protocol InvoiceDeletor {
    func deleteInvoice(id: String) async throws
}

class DefaultInvoiceDeletor: InvoiceDeletor {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    func deleteInvoice(id: String) async throws {
        let urlRequest = try await requestGenerator.generateRequest(endpoint: .invoiceId, method: .DELETE, headers: [:],
                                                                    pathKeysValues: ["invoiceId" : id], queryParameters: nil)
        try await apiCaller.call(urlRequest)
    }
}

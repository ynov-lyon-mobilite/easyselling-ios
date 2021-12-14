//
//  DefaultInvoiceFileInformationsGetter.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 11/12/2021.
//

import Foundation

protocol InvoiceFileInformationsGetter {
    func getInvoiceFile(of fileId: String) async throws -> InvoiceFile
}

class DefaultInvoiceFileInformationsGetter: InvoiceFileInformationsGetter {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    func getInvoiceFile(of fileId: String) async throws -> InvoiceFile {
        let fileRequest = try await requestGenerator.generateRequest(endpoint: .fileById,
                                                                 method: .GET,
                                                                     headers: [:],
                                                                 pathKeysValues: ["fileId": fileId],
                                                                 queryParameters: nil)
        let invoiceFile: InvoiceFile = try await apiCaller.call(fileRequest, decodeType: InvoiceFile.self)

        return invoiceFile
    }
}

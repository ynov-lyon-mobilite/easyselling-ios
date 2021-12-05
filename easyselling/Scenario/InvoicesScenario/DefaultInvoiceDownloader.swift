//
//  DefaultInvoiceDownloader.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 05/12/2021.
//

import Foundation
import UIKit

protocol InvoiceDownloader {
    func downloadInvoiceFile(id: String, ofType type: String) async throws -> UIImage
}

class DefaultInvoiceDownloader: InvoiceDownloader {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    func downloadInvoiceFile(id: String, ofType type: String) async throws -> UIImage {
        let downloadFileRequest = try await requestGenerator.generateRequest(endpoint: .downloadFile,
                                                                             method: .GET,
                                                                             headers: ["Content-Type": type],
                                                                             pathKeysValues: ["fileId": id],
                                                                             queryParameters: nil)
        return try await apiCaller.callImage(downloadFileRequest)
    }
}

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
                                                                 headers: ["Content-Type": "application/json"],
                                                                 pathKeysValues: ["fileId": fileId],
                                                                 queryParameters: nil)
        let invoiceFile: InvoiceFile = try await apiCaller.call(fileRequest, decodeType: InvoiceFile.self)

        return invoiceFile
    }
}

//
//  DefaultInvoiceDownloader.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 05/12/2021.
//

import Foundation
import UIKit

protocol InvoiceDownloader {
    func downloadInvoiceFile(id: String) async throws -> UIImage
}

class DefaultInvoiceDownloader: InvoiceDownloader {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), imageCaller: ImageCaller = DefaultImageCaller()) {
        self.requestGenerator = requestGenerator
        self.imageCaller = imageCaller
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var imageCaller: ImageCaller

    func downloadInvoiceFile(id: String) async throws -> UIImage {
        let downloadFileRequest = try await requestGenerator.generateRequest(endpoint: .fileById,
                                                                             method: .GET,
                                                                             headers: [:],
                                                                             pathKeysValues: ["fileId": id],
                                                                             queryParameters: nil)
        return try await imageCaller.callImage(downloadFileRequest)
    }
}

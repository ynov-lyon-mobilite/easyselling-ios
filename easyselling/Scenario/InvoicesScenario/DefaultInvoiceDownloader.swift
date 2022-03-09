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
        do {
            let downloadFileRequest = try await requestGenerator.generateRequest(endpoint: .downloadFile,
                                                                                 method: .GET,
                                                                                 headers: [:],
                                                                                 pathKeysValues: ["fileId": id],
                                                                                 queryParameters: nil)
            let image = try await imageCaller.callImage(downloadFileRequest)

            /*try mainContext.performAndWait {
                let invoice = InvoiceCoreData.fetchRequestById(id: Int(id) ?? -1)

                invoice?.fileData = image.pngData() ?? Data()

                if mainContext.hasChanges {
                    try mainContext.save()
                }
            }*/
            return image
        } catch(_) {
            var invoice: InvoiceCoreData?
            mainContext.performAndWait {
                invoice = InvoiceCoreData.fetchRequestById(id: Int(id) ?? -1)
            }

            return UIImage(data: invoice?.fileData ?? Data()) ?? UIImage()
        }
    }
}

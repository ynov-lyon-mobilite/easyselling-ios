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
            print(id)
            let downloadFileRequest = try await requestGenerator.generateRequest(endpoint: .fileById,
                                                                                 method: .GET,
                                                                                 headers: [:],
                                                                                 pathKeysValues: ["fileId": id],
                                                                                 queryParameters: nil)
            let image = try await imageCaller.callImage(downloadFileRequest)

            mainContext.performAndWait {
                let invoiceCoreData = InvoiceCoreData.fetchRequestById(id: id)
                invoiceCoreData?.fileData = image.pngData()
                print(image.pngData())
                if mainContext.hasChanges {
                    try? mainContext.save()
                }
            }

            return image
        } catch (_) {
            var image = UIImage()
            mainContext.performAndWait {
                let invoiceCoreData = InvoiceCoreData.fetchRequestById(id: id)

                if let data = invoiceCoreData?.fileData {
                    image = UIImage(data: data) ?? UIImage()
                }

            }
            return image
        }
    }
}

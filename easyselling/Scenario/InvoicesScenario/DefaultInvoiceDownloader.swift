//
//  DefaultInvoiceDownloader.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 05/12/2021.
//

import Foundation
import UIKit
import CoreData

protocol InvoiceDownloader {
    func downloadInvoiceFile(id: String) async throws -> UIImage
}

class DefaultInvoiceDownloader: InvoiceDownloader {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(),
         imageCaller: ImageCaller = DefaultImageCaller(),
         context: NSManagedObjectContext) {
        self.requestGenerator = requestGenerator
        self.imageCaller = imageCaller
        self.context = context
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var imageCaller: ImageCaller
    private var context: NSManagedObjectContext

    func downloadInvoiceFile(id: String) async throws -> UIImage {
        do {
            let downloadFileRequest = try await requestGenerator.generateRequest(endpoint: .fileById,
                                                                                 method: .GET,
                                                                                 headers: [:],
                                                                                 pathKeysValues: ["fileId": id],
                                                                                 queryParameters: nil)
            let image = try await imageCaller.callImage(downloadFileRequest)

            context.performAndWait {
                let invoiceCoreData = InvoiceCoreData.fetchRequestByTitle(title: id)
                invoiceCoreData?.fileData = image.pngData()
                if context.hasChanges {
                    try? context.save()
                }
            }

            return image
        } catch (_) {
            var image = UIImage()
            context.performAndWait {
                let invoiceCoreData = InvoiceCoreData.fetchRequestByTitle(title: id)

                if let data = invoiceCoreData?.fileData {
                    image = UIImage(data: data) ?? UIImage()
                }

            }
            return image
        }
    }
}

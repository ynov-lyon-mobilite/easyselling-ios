//
//  FailingInvoiceDownloader.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 05/12/2021.
//

@testable import easyselling
import UIKit

class FailingInvoiceDownloader: InvoiceDownloader {
    func downloadInvoiceFile(id: String, ofType type: String) async throws -> UIImage {
        throw APICallerError.unauthorized

    }
}

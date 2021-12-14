//
//  FailingInvoiceDownloader.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 05/12/2021.
//

@testable import easyselling
import UIKit

class FailingInvoiceDownloader: InvoiceDownloader {

    init(withError error: APICallerError) {
        self.error = error
    }

    private let error: APICallerError

    func downloadInvoiceFile(id: String) async throws -> UIImage {
        throw error
    }
}

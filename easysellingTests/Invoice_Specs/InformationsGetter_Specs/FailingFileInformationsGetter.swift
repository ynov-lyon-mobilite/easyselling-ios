//
//  FailingFileInformationsGetter.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 05/12/2021.
//

@testable import easyselling

class FailingFileInformationsGetter: InvoiceFileInformationsGetter {

    func getInvoiceFile(of fileId: String) async throws -> InvoiceFile {
        throw APICallerError.notFound
    }
}

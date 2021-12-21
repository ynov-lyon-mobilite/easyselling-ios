//
//  SucceedingFileInformationsGetter.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 05/12/2021.
//

@testable import easyselling

class SucceedingFileInformationsGetter: InvoiceFileInformationsGetter {
    
    func getInvoiceFile(of fileId: String) async throws -> InvoiceFile {
        InvoiceFile(title: "title", type: "type")
    }
}

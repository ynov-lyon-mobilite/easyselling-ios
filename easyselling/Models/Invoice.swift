//
//  Invoice.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 16/02/2022.
//

import Foundation
import CloudKit

struct Invoice: Decodable, Equatable {
    let id: Int16
    let vehicle: String
    let file: String
    let dateCreated: String
    let dateUpdated: String?

    static func convertInDTOObject(invoice: Invoice) -> InvoiceDTO {
        return InvoiceDTO(id: Int(invoice.id), vehicle: invoice.vehicle, file: invoice.file, dateCreated: invoice.dateCreated, dateUpdated: invoice.dateUpdated ?? "")
    }

    static func convertInCoreDataObject(invoice: Invoice) -> InvoiceCoreData {
        let invoiceCoreData = InvoiceCoreData(context: mainContext)
        invoiceCoreData.id = invoice.id
        invoiceCoreData.vehicle = invoice.vehicle
        invoiceCoreData.file = invoice.file
        invoiceCoreData.dateCreated = invoice.dateCreated
        invoiceCoreData.dateUpdated = invoice.dateUpdated
        return invoiceCoreData
    }
}

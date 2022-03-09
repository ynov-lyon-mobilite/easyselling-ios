//
//  Invoice.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 26/01/2022.
//
//

import Foundation

struct Invoice: Decodable {
    var id : Int
    var vehicle : String
    var file : String
    var dateCreated : String
    var dateUpdated : String?
    var fileData: Data?
    var fileTitle: String?

    static func toEncodableStruct (invoice: Invoice) -> InvoiceDTO {
        return InvoiceDTO(vehicle: invoice.vehicle, file: invoice.file, dateCreated: invoice.dateCreated, dateUpdated: invoice.dateUpdated ?? "")
    }

    static func toCoreDataObject (invoice: Invoice) -> InvoiceCoreData {
        return InvoiceCoreData(id: Int16(invoice.id), vehicle: invoice.vehicle, file: invoice.file, dateCreated: invoice.dateCreated, dateUpdated: invoice.dateUpdated)
    }

    static func fromCoreDataToObject (invoice: InvoiceCoreData) -> Invoice {
        return Invoice(id: Int(invoice.id), vehicle: invoice.vehicle, file: invoice.file, dateCreated: invoice.dateCreated, dateUpdated: invoice.dateUpdated)
    }
}

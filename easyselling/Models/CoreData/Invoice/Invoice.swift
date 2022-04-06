//
//  Invoice.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 09/03/2022.
//

import Foundation
import CoreData

struct Invoice: Decodable, Equatable {
    var id : String
    var fileData: Data?
    var file: FileResponse?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case file
    }

    static func toEncodableStruc (invoice: Invoice) -> InvoiceDTO {
        return InvoiceDTO(file: String(invoice.id))
    }

    static func toCoreDataObject (invoice: Invoice, in context: NSManagedObjectContext) -> InvoiceCoreData {
        return InvoiceCoreData(id: invoice.id, fileTitle: invoice.file?.filename, fileData: invoice.fileData ?? Data(), in: context)
    }

    static func fromCoreDataToObject (invoice: InvoiceCoreData) -> Invoice {
        return Invoice(id: invoice.id, fileData: invoice.fileData, file: FileResponse(filename: invoice.fileTitle ?? ""))
    }

    static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        return true
    }

}

struct FileResponse: Decodable {
    var filename: String
}

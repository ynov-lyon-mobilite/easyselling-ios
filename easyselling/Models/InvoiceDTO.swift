//
//  InvoiceDTO.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 11/11/2021.
//

import Foundation
import CoreData

struct InvoiceDTO : Codable, Equatable, Identifiable {
    var id : Int
    var vehicle : String
    var file : String
    var dateCreated : String
    var dateUpdated : String?

    init(id: Int, vehicle: String, file: String, dateCreated : String, dateUpdated : String) {
        self.id = id
        self.vehicle = vehicle
        self.file = file
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        let areEqual = lhs.id == rhs.id &&
        lhs.vehicle == rhs.vehicle && lhs.file == rhs.file

        return areEqual
    }

    func convertToInvoice() -> Invoice {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Invoice", in: mainContext)!
        let invoiceCoreData = Invoice(entity: entityDescription, insertInto: mainContext)
        invoiceCoreData.id = Int16(id)
        invoiceCoreData.vehicle = vehicle
        invoiceCoreData.file = file
        invoiceCoreData.dateCreated = dateCreated
        invoiceCoreData.dateUpdated = dateUpdated

        return invoiceCoreData
    }
}

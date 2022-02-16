//
//  Invoice.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 11/11/2021.
//

import Foundation

struct Invoice : Codable, Equatable, Identifiable {
    let id: String
    let vehicle : String
    let file : InvoiceFile

    enum CodingKeys: String, CodingKey {
        case vehicle, file
        case id = "_id"
    }

    init(id: String, vehicle: String, file: InvoiceFile) {
        self.id = id
        self.vehicle = vehicle
        self.file = file
    }

    static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        let areEqual = lhs.id == rhs.id &&
        lhs.vehicle == rhs.vehicle && lhs.file == rhs.file

        return areEqual
    }
}

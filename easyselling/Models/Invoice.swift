//
//  Invoice.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 11/11/2021.
//

import Foundation

struct Invoice : Codable, Equatable, Identifiable {

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

    static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        let areEqual = lhs.id == rhs.id &&
        lhs.vehicle == rhs.vehicle && lhs.file == rhs.file

        return areEqual
    }
}

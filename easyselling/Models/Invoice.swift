//
//  Invoice.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 11/11/2021.
//

import Foundation

class Invoice : Codable, Equatable, Identifiable {

    var id : Int
    var vehicle : String
    var file : String
    var date_created : String
    var date_updated : String?

    init(id: Int, vehicle: String, file: String, date_created : String, date_updated : String) {
        self.id = id
        self.vehicle = vehicle
        self.file = file
        self.date_created = date_created
        self.date_updated = date_updated
    }

    static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        let areEqual = lhs.id == rhs.id &&
        lhs.vehicle == rhs.vehicle && lhs.file == rhs.file

        return areEqual
    }
}

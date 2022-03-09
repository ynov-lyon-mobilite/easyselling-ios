//
//  InvoiceDTO.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 11/11/2021.
//

import Foundation
import CoreData

struct InvoiceDTO : Codable, Equatable {
    var vehicle : String
    var file : String
    var dateCreated : String
    var dateUpdated : String?

    init(vehicle: String, file: String, dateCreated : String, dateUpdated : String) {
        self.vehicle = vehicle
        self.file = file
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
    }
}

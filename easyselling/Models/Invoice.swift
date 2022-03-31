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
}

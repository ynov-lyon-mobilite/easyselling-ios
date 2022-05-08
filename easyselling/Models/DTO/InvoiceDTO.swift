//
//  Invoice.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 11/11/2021.
//

import Foundation

struct InvoiceDTO: Codable {
    let file : String
    let label: String
    let mileage: Int
    let date: Date
}

//
//  Invoice.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 11/11/2021.
//

import Foundation

struct InvoiceDTO: Codable {
    let file : String

    init(file: String) {
        self.file = file
    }
}

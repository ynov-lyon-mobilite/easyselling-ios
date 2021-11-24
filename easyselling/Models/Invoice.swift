//
//  Invoice.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 11/11/2021.
//

import Foundation

class Invoice {
    var idInvoice : String
    var idVehicule : String
    
    init(idInvoice: String, idVehicule: String) {
        self.idInvoice = idInvoice
        self.idVehicule = idVehicule
    }
}

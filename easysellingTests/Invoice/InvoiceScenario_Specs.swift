//
//  InvoiceScenario_Specs.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 11/11/2021.
//

import Foundation
import XCTest

class InvoiceScenario_Spec: XCTestCase {
    private var result: Bool!
    private let idVehicule: String = "Dej-123-dfghjd-45-ajhdk-6789"
    
    func test_Opens_invoice_screen() {
        
    }
    
    func test_Succeeds_getting_invoices_of_a_vehicule() {
        let invoiceService = InvoiceService(httpCode: 200)
        invoiceService.getInvoice(idVehicule: idVehicule) { success in
            self.result = success
        }
        XCTAssertTrue(self.result)
    }
    
    func test_Fails_getting_invoices_of_a_vehicule() {        
        let invoiceService = InvoiceService(httpCode: 400)
        invoiceService.getInvoice(idVehicule: idVehicule) { failure in
            self.result = failure
        }
        XCTAssertFalse(self.result)
    }
    
    func test_Clicks_on_invoice() {
        
    }
    
    func test_Gets_information_of_the_invoice() {
        
    }
}


class InvoiceService {
    private var httpCode: Int
    
    init(httpCode: Int) {
        self.httpCode = httpCode
    }
    
    func getInvoice(idVehicule: String, onEnd: @escaping (_: Bool) -> Void) {
        switch(httpCode) {
        case 200:
            onEnd(true)
            
        default:
            onEnd(false)
        }
    }
}

//
//  FailingInvoiceDeletor.swift
//  easysellingTests
//
//  Created by Pierre Gourgouillon on 15/12/2021.
//

import Foundation
@testable import easyselling

class FailingInvoiceDeletor: InvoiceDeletor {

    init(withError error: APICallerError) {
        self.error = error
    }

    private var error: APICallerError

    func deleteInvoice(id: Int) async throws {
        throw error
    }
}

//
//  TaskInvoicesGetter.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 26/01/2022.
//

import Foundation
import SwiftUI

class TaskInvoicesGetter {

    private let invoices: [InvoiceDTO]

    init(invoices: [InvoiceDTO]) {
        self.invoices = invoices
    }

    func insertInvoices() {
        let datas = invoices.map { $0.convertToInvoice() }
        save()
    }

    private func save() {
        do {
            try AppDelegate.mainContext.save()
        } catch {
            print("Une erreur est survenue")
        }
    }
}

//
//  TaskInvoicesPost.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 26/01/2022.
//

import Foundation
import SwiftUI

class TaskInvoicesPost {

    private let invoices: [InvoiceDTO]

    init(invoices: [InvoiceDTO]) {
        self.invoices = invoices
    }

    func insertInvoices() {
        _ = invoices.map { $0.convertToInvoice() }
        save()
    }

    private func save() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Une erreur est survenue")
        }
    }
}

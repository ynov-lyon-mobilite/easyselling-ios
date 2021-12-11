//
//  InvoiceViewerViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 05/12/2021.
//

import Foundation

class InvoiceViewerViewModel: ObservableObject {

    init(invoiceFile: File) {
        self.invoiceFile = invoiceFile
    }

    let invoiceFile: File
}

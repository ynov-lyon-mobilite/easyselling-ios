//
//  VehicleInvoiceViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 24/11/2021.
//

import Foundation
import UIKit
import SwiftUI

class VehicleInvoiceViewModel: ObservableObject {

    private var vehicleInvoicesGetter: VehicleInvoicesGetter
    private var invoiceDownloader: InvoiceDownloader
    private var onNavigatingToInvoiceView: (File) -> Void
    private var invoiceDeletor: InvoiceDeletor

    @Published var vehicleId: String
    @Published var invoices: [Invoice] = []
    @Published var error: APICallerError?
    var chosenInvoice: Int16?
    @Published var isLoading: Bool = true
    @Published var isDownloading: Bool = false
    @Published var isError: Bool = false

    let vehicleId: String

    init(ofVehicleId: String,
         invoiceDeletor: InvoiceDeletor = DefaultInvoiceDeletor(),
         vehicleInvoicesGetter: VehicleInvoicesGetter = DefaultVehicleInvoicesGetter(),
         invoiceDownloader: InvoiceDownloader = DefaultInvoiceDownloader(),
         onNavigatingToInvoiceView: @escaping (File) -> Void) {

        self.vehicleId = ofVehicleId
        self.invoiceDeletor = invoiceDeletor
        self.vehicleInvoicesGetter = vehicleInvoicesGetter
        self.invoiceDownloader = invoiceDownloader
        self.onNavigatingToInvoiceView = onNavigatingToInvoiceView
    }

    @MainActor func getInvoices(ofVehicleId vehicleId: String) async {
        do {
            invoices = try await vehicleInvoicesGetter.getInvoices(ofVehicleId: vehicleId)
            print(invoices)
        } catch (let error) {
            if let error = error as? APICallerError {
                isError = true
                self.error = error
            } else {
                self.error = nil
            }
        }
        isLoading = false
    }

    @MainActor func downloadInvoiceContent(filename: String) async {
        isDownloading = true
        do {
            let invoiceImage = try await invoiceDownloader.downloadInvoiceFile(id: filename)
            isDownloading = false
            self.onNavigatingToInvoiceView(File(title: filename, image: invoiceImage))
        } catch(let error) {
            if let error = error as? APICallerError {
                isError = true
                self.error = error
            } else {
                self.error = nil
            }
            isDownloading = false
        }
    }

    @MainActor func deleteInvoice(idInvoice: String) async {
        do {
            try await invoiceDeletor.deleteInvoice(id: idInvoice)
            deleteInvoiceOnTheView(idInvoice: idInvoice)
        } catch (let error) {
            if let error = error as? APICallerError {
                self.error = error
            }
        }
    }

    private func deleteInvoiceOnTheView(idInvoice: String) {
        invoices = invoices.filter { $0.id != idInvoice }
    }
}

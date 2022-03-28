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

    private let vehicleInvoicesGetter: VehicleInvoicesGetter
    private let invoiceDownloader: InvoiceDownloader
    private let onNavigatingToInvoiceView: (File) -> Void
    private let invoiceDeletor: InvoiceDeletor
    private let isOpeningInvoiceCreation: (Vehicle, @escaping () async -> Void) -> Void
    private let vehicle: Vehicle

    @Published var invoices: [Invoice] = []
    @Published var error: APICallerError?
    @Published var isLoading: Bool = true
    @Published var isDownloading: Bool = false
    @Published var isError: Bool = false

    init(vehicle: Vehicle,
         invoiceDeletor: InvoiceDeletor = DefaultInvoiceDeletor(),
         vehicleInvoicesGetter: VehicleInvoicesGetter = DefaultVehicleInvoicesGetter(),
         invoiceDownloader: InvoiceDownloader = DefaultInvoiceDownloader(),
         onNavigatingToInvoiceView: @escaping (File) -> Void,
         isOpeningInvoiceCreation: @escaping (Vehicle, @escaping () async -> Void) -> Void) {

        self.vehicle = vehicle
        self.invoiceDeletor = invoiceDeletor
        self.vehicleInvoicesGetter = vehicleInvoicesGetter
        self.invoiceDownloader = invoiceDownloader
        self.onNavigatingToInvoiceView = onNavigatingToInvoiceView
        self.isOpeningInvoiceCreation = isOpeningInvoiceCreation
    }

    func openInvoiceCreation() {
        self.isOpeningInvoiceCreation(vehicle) { [weak self] in
            await self?.getInvoices()
        }
    }

    @MainActor func getInvoices() async {
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

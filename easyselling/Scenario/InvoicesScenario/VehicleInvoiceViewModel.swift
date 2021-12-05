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
    private var invoiceFileInformationsGetter: InvoiceFileInformationsGetter
    private var onNavigatingToInvoiceView: (File) -> Void

    @Published var vehicleId: String
    @Published var isLoading: Bool = true
    @Published var invoices: [Invoice] = []
    @Published var error: APICallerError?
    @Published var isError: Bool = false

    init(ofVehicleId: String,
         vehicleInvoicesGetter: VehicleInvoicesGetter = DefaultVehicleInvoicesGetter(),
         invoiceDownloader: InvoiceDownloader = DefaultInvoiceDownloader(),
         invoiceFileInformationsGetter: InvoiceFileInformationsGetter = DefaultInvoiceFileInformationsGetter(),
         onNavigatingToInvoiceView: @escaping (File) -> Void) {

        self.vehicleId = ofVehicleId
        self.vehicleInvoicesGetter = vehicleInvoicesGetter
        self.invoiceDownloader = invoiceDownloader
        self.invoiceFileInformationsGetter = invoiceFileInformationsGetter
        self.onNavigatingToInvoiceView = onNavigatingToInvoiceView
    }

    @MainActor func getInvoices(ofVehicleId vehicleId: String) async {
        do {
            invoices = try await vehicleInvoicesGetter.getInvoices(ofVehicleId: vehicleId)
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

    @MainActor func downloadInvoiceContent(of fileId: String) async {
        do {
            let invoiceFile = try await invoiceFileInformationsGetter.getInvoiceFile(of: fileId)
            let invoiceImage = try await invoiceDownloader.downloadInvoiceFile(id: fileId, ofType: invoiceFile.type)

            self.onNavigatingToInvoiceView(File(title: invoiceFile.title, image: invoiceImage))
        } catch(let error) {
            print(error)
        }
    }
}

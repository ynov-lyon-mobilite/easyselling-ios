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

    @Published var vehicleId: String
    @Published var isLoading: Bool = true
    @Published var invoices: [Invoice] = []
    @Published var error: APICallerError?
    @Published var isError: Bool = false

    init(vehicleInvoicesGetter: VehicleInvoicesGetter = DefaultVehicleInvoicesGetter(), ofVehicleId: String) {
        self.vehicleInvoicesGetter = vehicleInvoicesGetter
        self.vehicleId = ofVehicleId
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
}

//
//  DefaultInvoicesNavigator.swift
//  easyselling
//
//  Created by Corentin Laurencine on 24/11/2021.
//

import UIKit
import SwiftUI

protocol InvoiceNavigator {

    func navigatesToInvoicesView(of vehicle: String, onNavigatingToInvoice: @escaping (File) -> Void)
    func navigateToInvoice(_ file: File)
}

class DefaultInvoicesNavigator: InvoiceNavigator {
    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigatesToInvoicesView(of vehicle: String, onNavigatingToInvoice: @escaping (File) -> Void) {
        let vm = VehicleInvoiceViewModel(ofVehicleId: vehicle, onNavigatingToInvoiceView: onNavigatingToInvoice)
        let invoicesView = VehicleInvoicesView(viewModel: vm)
        navigationController.pushViewController(UIHostingController(rootView: invoicesView), animated: true)
    }

    func navigateToInvoice(_ file: File) {
        let vm = InvoiceViewerViewModel(invoiceFile: file)
        let view = InvoiceView(viewModel: vm)
        navigationController.pushViewController(UIHostingController(rootView: view), animated: true)
    }
}

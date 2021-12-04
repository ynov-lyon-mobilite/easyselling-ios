//
//  DefaultInvoicesNavigator.swift
//  easyselling
//
//  Created by Corentin Laurencine on 24/11/2021.
//

import UIKit
import SwiftUI

protocol InvoiceNavigator {

    func navigatesToInvoicesView(of vehicle: String, onNavigatingToInvoice: @escaping (String) -> Void)
    func navigateToInvoice(_ invoiceId: String)
}

class DefaultInvoicesNavigator: InvoiceNavigator {
    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigatesToInvoicesView(of vehicle: String, onNavigatingToInvoice: @escaping (String) -> Void) {
        let vm = VehicleInvoiceViewModel(ofVehicleId: vehicle)
        let invoicesView = VehicleInvoiceView(viewModel: vm)
        navigationController.pushViewController(UIHostingController(rootView: invoicesView), animated: true)
    }

    func navigateToInvoice(_ invoiceId: String) {
        
    }
}

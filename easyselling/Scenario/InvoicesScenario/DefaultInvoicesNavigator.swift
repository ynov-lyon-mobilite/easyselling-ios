//
//  DefaultInvoicesNavigator.swift
//  easyselling
//
//  Created by Corentin Laurencine on 24/11/2021.
//

import UIKit
import SwiftUI

protocol InvoiceNavigator {
    func navigatesToInvoicesView(
        of vehicle: Vehicle,
        onNavigatingToInvoice: @escaping (File) -> Void,
        onNavigatingToInvoiceCreation: @escaping (Vehicle, @escaping () async -> Void) -> Void
    )
    func navigatesToInvoice(_ file: File)
    func navigatesToInvoiceCreation(vehicle: Vehicle, onFinish: @escaping () async -> Void)
    func goingBackToVehicleInvoicesView()
}

class DefaultInvoicesNavigator: InvoiceNavigator {

    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigatesToInvoicesView(
        of vehicle: Vehicle,
        onNavigatingToInvoice: @escaping (File) -> Void,
        onNavigatingToInvoiceCreation: @escaping (Vehicle, @escaping () async -> Void) -> Void) {
        let vm = VehicleInvoiceViewModel(vehicle: vehicle, onNavigatingToInvoiceView: onNavigatingToInvoice, isOpeningInvoiceCreation: onNavigatingToInvoiceCreation)
        let invoicesView = VehicleInvoicesView(viewModel: vm)
        navigationController.pushViewController(UIHostingController(rootView: invoicesView), animated: true)
    }

    func navigatesToInvoiceCreation(vehicle: Vehicle, onFinish: @escaping () async -> Void) {
        let vm = InvoiceCreationViewModel(vehicle: vehicle, onFinish: onFinish)

        let invoiceCreationView = InvoiceCreationView(viewModel: vm)
        navigationController.present(UIHostingController(rootView: invoiceCreationView), animated: true)
    }

    func navigatesToInvoice(_ file: File) {
        let vm = InvoiceViewerViewModel(invoiceFile: file)
        let view = InvoiceView(viewModel: vm)
        navigationController.pushViewController(UIHostingController(rootView: view), animated: true)
    }

    func goingBackToVehicleInvoicesView() {
        DispatchQueue.main.async {
            self.navigationController.dismiss(animated: true)
        }
    }

}

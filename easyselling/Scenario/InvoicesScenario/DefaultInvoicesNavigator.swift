//
//  DefaultInvoicesNavigator.swift
//  easyselling
//
//  Created by Corentin Laurencine on 24/11/2021.
//

import UIKit
import SwiftUI

protocol InvoiceNavigator {

    func navigatesToInvoicesView(_: String)

}

class DefaultInvoicesNavigator: InvoiceNavigator {
    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigatesToInvoicesView(_ vehicleId: String) {
        let vm = VehicleInvoiceViewModel(ofVehicleId: vehicleId)
        let invoicesView = VehicleInvoiceView(viewModel: vm)
        navigationController.pushViewController(UIHostingController(rootView: invoicesView), animated: true)
    }
}

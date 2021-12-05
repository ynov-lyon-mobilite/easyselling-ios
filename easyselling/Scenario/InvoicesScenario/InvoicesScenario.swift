//
//  InvoicesScenario.swift
//  easyselling
//
//  Created by Corentin Laurencine on 24/11/2021.
//

class InvoicesScenario {

    init(navigator: InvoiceNavigator) {
        self.navigator = navigator
    }

    private var navigator: InvoiceNavigator

    func begin(withVehicleId vehicleId: String) {
        navigator.navigatesToInvoicesView(of: vehicleId, onNavigatingToInvoice: navigateToInvoice)
    }

    private func navigateToInvoice(_ file: File) {
        navigator.navigateToInvoice(file)
    }
}

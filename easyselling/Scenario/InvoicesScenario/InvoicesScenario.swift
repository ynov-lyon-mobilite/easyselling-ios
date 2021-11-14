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

    func begin(vehicle: Vehicle) {
        navigator.navigatesToInvoicesView(of: vehicle, onNavigatingToInvoice: navigatesToInvoice, onNavigatingToInvoiceCreation: navigatesToInvoiceCreation)
    }

    private func navigatesToInvoice(_ file: File) {
        navigator.navigatesToInvoice(file)
    }

    private func navigatesToInvoiceCreation(vehicle: Vehicle, onDismiss: @escaping () async -> Void) {
        navigator.navigatesToInvoiceCreation(vehicle: vehicle, onFinish: { [weak self] in
            self?.goingBackToVehicleInvoicesView()
            await onDismiss()
        })
    }

    private func goingBackToVehicleInvoicesView() {
        navigator.goingBackToVehicleInvoicesView()
    }
}

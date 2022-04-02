//
//  InvoicesScenario_Specs.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 24/11/2021.
//

@testable import easyselling
import XCTest

class InvoicesScenario_Spec: XCTestCase {

    func test_Begins_scenario() {
        givenScenario()
        whenBeginning()
        thenHistory(is: [.invoices])
    }

    func test_Navigates_to_invoice_view() {
        givenScenario()
        whenBeginning()
        whenNavigatingToInvoiceView()
        thenHistory(is: [.invoices, .invoiceView])
    }

    func test_Navigates_to_invoice_creation() {
        givenScenario()
        whenBeginning()
        whenNavigatingToInvoiceCreation()
        thenHistory(is: [.invoices, .invoiceCreation])
    }

    func test_Leaves_invoice_creation() async {
        givenScenario()
        whenBeginning()
        whenNavigatingToInvoiceCreation()
        await whenLeavingInvoiceCreation()
        thenHistory(is: [.invoices, .invoiceCreation, .invoices])
    }

    private func givenScenario() {
        navigator = SpyInvoicesNavigator()
        scenario = InvoicesScenario(navigator: navigator)
    }

    private func whenBeginning() {
        scenario.begin(vehicle: vehicle)
    }

    private func whenNavigatingToInvoiceView() {
        navigator.onNavigatingToInvoice?(File(title: "", image: UIImage()))
    }

    private func whenNavigatingToInvoiceCreation() {
        navigator.onNavigatingToInvoiceCreation?(vehicle, {})
    }

    private func whenLeavingInvoiceCreation() async {
        await navigator.onFinish?()
    }

    private func thenHistory(is expected: [SpyInvoicesNavigator.History]) {
        XCTAssertEqual(expected, navigator.history)
    }

    private let vehicle = Vehicle(id: "1", brand: "Brand", model: "Model", licence: "Licence", type: .car, year: "year")
    private var scenario: InvoicesScenario!
    private var navigator: SpyInvoicesNavigator!

}

class SpyInvoicesNavigator: InvoiceNavigator {
    private(set) var history: [History] = []
    private(set) var onFinish: AsyncableAction?
    private(set) var onNavigatingToInvoice: ((File) -> Void)?
    private(set) var onNavigatingToInvoiceCreation: ( (Vehicle, @escaping () async -> Void) -> Void)?

    func navigatesToInvoicesView(of vehicle: Vehicle, onNavigatingToInvoice: @escaping (File) -> Void, onNavigatingToInvoiceCreation: @escaping (Vehicle, @escaping () async -> Void) -> Void) {
        self.onNavigatingToInvoice = onNavigatingToInvoice
        self.onNavigatingToInvoiceCreation = onNavigatingToInvoiceCreation
        history.append(.invoices)
    }

    func navigatesToInvoiceCreation(vehicle: Vehicle, onFinish: @escaping () async -> Void) {
        self.onFinish = onFinish
        history.append(.invoiceCreation)
    }

    func navigatesToInvoice(_ file: File) {
        history.append(.invoiceView)
    }

    func goingBackToVehicleInvoicesView() {
        history.append(.invoices)
    }

    enum History: CustomDebugStringConvertible, Equatable {
        case invoices
        case invoiceView
        case invoiceCreation

        var debugDescription: String {
            switch self {
                case .invoices: return "Invoices"
                case .invoiceView: return "View of invoice"
                case .invoiceCreation: return "Creation of invoice"
            }
        }
    }
}

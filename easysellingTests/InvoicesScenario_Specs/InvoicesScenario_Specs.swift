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

    private func givenScenario() {
        navigator = SpyInvoicesNavigator()
        scenario = InvoicesScenario(navigator: navigator)
    }

    private func whenBeginning() {
        scenario.begin(withVehicleId: "VehicleID")
    }

    private func whenNavigatingToInvoiceView() {
        navigator.onNavigatingToInvoice?("")
    }

    private func thenHistory(is expected: [SpyInvoicesNavigator.History]) {
        XCTAssertEqual(expected, navigator.history)
    }

    private var scenario: InvoicesScenario!
    private var navigator: SpyInvoicesNavigator!

}

class SpyInvoicesNavigator: InvoiceNavigator {
    
    private(set) var history: [History] = []
    private(set) var onNavigatingToInvoice: ((String) -> Void)?

    func navigatesToInvoicesView(of vehicle: String, onNavigatingToInvoice: @escaping (String) -> Void) {
        self.onNavigatingToInvoice = onNavigatingToInvoice
        history.append(.invoices)
    }

    func navigateToInvoice(_ invoiceId: String) {
        history.append(.invoiceView)
    }

    enum History: CustomDebugStringConvertible, Equatable {
        case invoices
        case invoiceView

        var debugDescription: String {
            switch self {
            case .invoices: return "Invoices"
            case .invoiceView: return "View of invoice"
            }
        }
    }
}

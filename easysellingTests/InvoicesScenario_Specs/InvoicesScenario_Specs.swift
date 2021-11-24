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

    private func givenScenario() {
        navigator = SpyInvoicesNavigator()
        scenario = InvoicesScenario(navigator: navigator)
    }

    private func whenBeginning() {
        scenario.begin(withVehicleId: "VehicleID")
    }

    private func thenHistory(is expected: [SpyInvoicesNavigator.History]) {
        XCTAssertEqual(expected, navigator.history)
    }

    private var scenario: InvoicesScenario!
    private var navigator: SpyInvoicesNavigator!

}

class SpyInvoicesNavigator: InvoiceNavigator {

    private(set) var history: [History] = []

    func navigatesToInvoicesView() {
        history.append(.invoices)
    }

    enum History: CustomDebugStringConvertible, Equatable {
        case invoices

        var debugDescription: String {
            switch self {
            case .invoices: return "Invoices"
            }
        }
    }
}

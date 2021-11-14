//
//  InvoiceCreationViewModel_Specs.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 15/12/2021.
//

import XCTest
@testable import easyselling

class InvoiceCreationViewModel_Specs: XCTestCase {

//    private var viewModel: InvoiceCreationViewModel!
//    private var isDismissed: Bool = false
//
//    func test_Throws_alert_when_an_error_happens_after_an_api_call() async {
//        givenViewModel()
//        await whenCreatingInvoice()
//        thenAlertIsShown()
//    }
//
//    func test_Dismisses_modal_when_invoice_creation_had_succeeded() async {
//        givenViewModel()
//        await whenInvoiceCreationIsSuccessful()
//        thenModalIsDismissed()
//    }
//
//    private func givenViewModel() {
//        viewModel = InvoiceCreationViewModel(vehicleID: "VehicleID", fileUploader: DefaultFileUploader(), invoiceCreator: SpyInvoiceCreator(), onFinish: { self.isDismissed = true })
//    }
//
//    private func whenCreatingInvoice() async {
//        await viewModel.createInvoice()
//    }
//
//    private func whenInvoiceCreationIsSuccessful() async {
//        await viewModel.dismissModal()
//    }
//
//    private func thenAlertIsShown() {
//        XCTAssertTrue(viewModel.showAlert)
//    }
//
//    private func thenModalIsDismissed() {
//        XCTAssertTrue(isDismissed)
//    }
}

class SpyInvoiceCreator: InvoiceCreator {
    func createInvoice(invoice: InvoiceDTO) async throws {
        throw APICallerError.internalServerError
    }
}

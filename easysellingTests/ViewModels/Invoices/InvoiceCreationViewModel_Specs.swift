//
//  InvoiceCreationViewModel_Specs.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 15/12/2021.
//

import XCTest
@testable import easyselling

class InvoiceCreationViewModel_Specs: XCTestCase {

    private var viewModel: InvoiceCreationViewModel!
    private var isDismissed: Bool = false

    func test_Opens_upload_modal() async {
        givenViewModel()
        whenOpenConfirmationDialog()
        thenConfirmationDialogIsOpen()
    }

    func test_Opens_scan_modal() {
        givenViewModel()
        whenOpenFileModal(type: .scan)
        thenFileModalIsOpen(type: .scan)
    }

    func test_Opens_confirmation_dialog() {
        givenViewModel()
        whenOpenFileModal(type: .scan)
        thenFileModalIsOpen(type: .scan)
    }

    func test_Throws_alert_when_an_error_happens_after_an_api_call() async {
        givenViewModel()
        await whenCreatingInvoice()
        thenAlertIsShown()
    }

    func test_Dismisses_modal_when_invoice_creation_had_succeeded() async {
        givenViewModel()
        await whenInvoiceCreationIsSuccessful()
        thenViewIsDismiss()
    }

    private func givenViewModel() {
        let vehicle = Vehicle(id: "VehicleID", brand: "Brand", model: "Model", licence: "licence", type: .car, year: "1795")
        viewModel = InvoiceCreationViewModel(vehicle: vehicle, fileUploader: SpyFileUploader(), invoiceCreator: SpyInvoiceCreator(), onFinish: { self.isDismissed = true })
    }

    private func whenCreatingInvoice() async {
        await viewModel.createInvoice()
    }

    private func whenOpenConfirmationDialog() {
        viewModel.openFileConfirmationDialog()
    }

    private func whenOpenFileModal(type: InvoiceCreationViewModel.FileSelectionType) {
        viewModel.openFileSectionSheet(type)
    }

    private func whenInvoiceCreationIsSuccessful() async {
        await viewModel.dismissModal()
    }

    private func thenViewIsDismiss() {
        XCTAssertTrue(isDismissed)
    }

    private func thenFileModalIsOpen(type: InvoiceCreationViewModel.FileSelectionType) {
        XCTAssertEqual(viewModel.fileSelectionType, type)
    }

    private func thenConfirmationDialogIsOpen() {
        XCTAssertTrue(viewModel.fileConfirmationDialogIsPresented)
    }

    private func thenAlertIsShown() {
        XCTAssertTrue(viewModel.alertIsPresented)
        XCTAssertNotNil(viewModel.alertError)
    }
}

class SpyInvoiceCreator: InvoiceCreator {
    func createInvoice(vehicleId: String, invoice: InvoiceDTO) async throws {
        throw APICallerError.internalServerError
    }
}

class SpyFileUploader: FileUploader {
    func upload(_ fileDTO: FileDTO) async throws -> UploadedFile {
        throw APICallerError.internalServerError
    }
}

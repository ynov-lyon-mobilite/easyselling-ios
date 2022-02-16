//
//  VehicleInvoiceViewModel_Specs.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 01/12/2021.
//

import XCTest
@testable import easyselling

class VehicleInvoiceViewModel_Specs: XCTestCase {

    func test_Shows_vehicle_invoices_when_request_succeeds() async {
        givenViewModel(vehicleInvoicesGetter: SucceedingVehicleInvoicesGetter(expectedVehicleInvoices))
        thenViewModelIsLoading()
        await whenTryingToGetVehicleInvoices()
        thenViewModelIsNotLoading()
        XCTAssertEqual([InvoiceCoreData(id: 1, vehicle: "1", file: "1", dateCreated: "date1", dateUpdated: ""),
                        InvoiceCoreData(id: 2, vehicle: "1", file: "2", dateCreated: "date2", dateUpdated: ""),
                        InvoiceCoreData(id: 3, vehicle: "2", file: "3", dateCreated: "date3", dateUpdated: "")], viewModel.invoices)
    }

    func test_Shows_error_when_request_is_failing() async {
        givenViewModel(vehicleInvoicesGetter: FailingVehicleInvoicesGetter(withError: APICallerError.notFound))
        thenViewModelIsLoading()
        await whenTryingToGetVehicleInvoices()
        thenError(is: "Impossible de trouver ce que vous cherchez")
        thenViewModelIsNotLoading()
    }

    func test_Download_invoice_file_when_user_tap_one_invoice() async {
        givenViewModel(vehicleInvoicesGetter: SucceedingVehicleInvoicesGetter(expectedVehicleInvoices),
                       invoiceDownloader: SucceedingInvoiceDownloader())
        await whenTryingToGetVehicleInvoices()
        await whenTryingToSeeInvoice("title")
        thenUserHasNavigateToInvoiceView()
        thenInvoiceFile(is: File(title: "title", image: UIImage()))
    }

    func test_Shows_error_when_dowloading_invoice_fail() async {
        givenViewModel(vehicleInvoicesGetter: SucceedingVehicleInvoicesGetter(expectedVehicleInvoices),
                       invoiceDownloader: FailingInvoiceDownloader(withError: .unauthorized))
        await whenTryingToSeeInvoice("1")
        thenError(is: "Une erreur est survenue")
    }

    func test_Deletes_invoice_when_request_is_success() async {
        givenViewModel(vehicleInvoicesGetter: SucceedingVehicleInvoicesGetter(expectedVehicleInvoices),
                              invoiceDeletor: SucceedingInvoiceDeletor())
        await whenTryingToGetVehicleInvoices()
        await whenDeletingInvoice(withId: "0AJEAZ8")
        thenLoadInvoices(are: [
            InvoiceCoreData(id: 2, vehicle: "1", file: "2", dateCreated: "date2", dateUpdated: ""),
            InvoiceCoreData(id: 3, vehicle: "2", file: "3", dateCreated: "date3", dateUpdated: "")])
    }

    func test_Shows_an_error_when_the_request_fails_when_deleting_an_invoice() async {
        givenViewModel(vehicleInvoicesGetter: SucceedingVehicleInvoicesGetter(expectedVehicleInvoices), invoiceDeletor: FailingInvoiceDeletor(withError: APICallerError.notFound))
        await whenDeletingInvoice(withId: "98YZG")
        thenError(is: "Impossible de trouver ce que vous cherchez")
    }

    private func givenViewModel(vehicleInvoicesGetter: VehicleInvoicesGetter,
                                invoiceDownloader: InvoiceDownloader = SucceedingInvoiceDownloader(),
                                invoiceDeletor: InvoiceDeletor = SucceedingInvoiceDeletor()) {

        viewModel = VehicleInvoiceViewModel(ofVehicleId: vehicleId,
                                            invoiceDeletor: invoiceDeletor,
                                            vehicleInvoicesGetter: vehicleInvoicesGetter,
                                            invoiceDownloader: invoiceDownloader,
                                            onNavigatingToInvoiceView: { invoice in
            self.onNavigatingToInvoiceView = true
            self.downloadedInvoice = invoice
        })
    }

    private func givenViewModelDeletor(invoicesGetter: VehicleInvoicesGetter, invoiceDeletor: InvoiceDeletor) {
        viewModel = VehicleInvoiceViewModel(ofVehicleId: vehicleId, invoiceDeletor: invoiceDeletor, vehicleInvoicesGetter: invoicesGetter,invoiceDownloader: SucceedingInvoiceDownloader(), onNavigatingToInvoiceView: { invoice in
            self.onNavigatingToInvoiceView = true
            self.downloadedInvoice = invoice
        })
    }

    private func whenDeletingInvoice(withId: String) async {
        await viewModel.deleteInvoice(idInvoice: withId)
    }

    private func whenTryingToGetVehicleInvoices() async {
        await viewModel.getInvoices(ofVehicleId: vehicleId)
    }

    private func whenTryingToSeeInvoice(_ invoiceId: String) async {
        await viewModel.downloadInvoiceContent(filename: invoiceId)
    }

    private func thenViewModelIsLoading() {
        XCTAssertTrue(viewModel.isLoading)
    }

    private func thenViewModelIsNotLoading() {
        XCTAssertFalse(viewModel.isLoading)
    }

    private func thenUserHasNavigateToInvoiceView() {
        XCTAssertTrue(onNavigatingToInvoiceView)
    }

    private func thenInvoiceFile(is expected: File) {
        XCTAssertEqual(expected, downloadedInvoice)
    }

    private func thenError(is expected: String) {
        XCTAssertEqual(expected, viewModel.error?.errorDescription)
    }

    private func thenLoadInvoices(are expected: [InvoiceCoreData]) {
        XCTAssertEqual(expected, viewModel.invoices)
    }

    private var viewModel: VehicleInvoiceViewModel!
    private var vehicleId: String = "1"
    private var downloadedInvoice: File!
    private var onNavigatingToInvoiceView: Bool = false
    private let expectedVehicleInvoices = [
        InvoiceCoreData(id: 1, vehicle: "1", file: "1", dateCreated: "date1", dateUpdated: ""),
        InvoiceCoreData(id: 2, vehicle: "1", file: "2", dateCreated: "date2", dateUpdated: ""),
        InvoiceCoreData(id: 3, vehicle: "2", file: "3", dateCreated: "date3", dateUpdated: "")]
}

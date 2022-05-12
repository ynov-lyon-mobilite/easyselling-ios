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
        XCTAssertEqual([Invoice(id: "0AJEAZ9", file: nil, label: "label1", mileage: 10000, date: Date().zeroSeconds, vehicle: "vehicle1"),
                        Invoice(id: "0AJEAZ8", file: nil, label: "label2", mileage: 10000, date: Date().zeroSeconds, vehicle: "vehicle2"),
                        Invoice(id: "0AJEAZ7", file: nil, label: "label3", mileage: 10000, date: Date().zeroSeconds, vehicle: "vehicle3")], viewModel.invoices)
    }

    func test_Shows_error_when_request_is_failing() async {
        givenViewModel(vehicleInvoicesGetter: FailingVehicleInvoicesGetter(withError: APICallerError.notFound))
        thenViewModelIsLoading()
        await whenTryingToGetVehicleInvoices()
        thenError(is: APICallerError.notFound.errorDescription)
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

    func test_Downloads_invoices_file_at_init_to_preview_invoices() async {
        givenViewModel(vehicleInvoicesGetter: SucceedingVehicleInvoicesGetter(expectedVehicleInvoices),
                       invoiceDownloader: SucceedingInvoiceDownloader())
        await whenTryingToGetVehicleInvoices()
        thenInvoicesFiles(are: [
        ])
    }

    func test_Shows_error_when_dowloading_invoice_fail() async {
        givenViewModel(vehicleInvoicesGetter: SucceedingVehicleInvoicesGetter(expectedVehicleInvoices),
                       invoiceDownloader: FailingInvoiceDownloader(withError: .unauthorized))
        await whenTryingToSeeInvoice("1")
        thenError(is: APICallerError.unauthorized.errorDescription)
    }

    func test_Deletes_invoice_when_request_is_success() async {
        givenViewModel(vehicleInvoicesGetter: SucceedingVehicleInvoicesGetter(expectedVehicleInvoices),
                              invoiceDeletor: SucceedingInvoiceDeletor())
        await whenTryingToGetVehicleInvoices()
        await whenDeletingInvoice(withId: "0AJEAZ8")
        thenLoadInvoices(are: [
            Invoice(id: "0AJEAZ9", file: nil, label: "label1", mileage: 10000, date: Date().zeroSeconds, vehicle: "vehicle1"),
            Invoice(id: "0AJEAZ7", file: nil, label: "label3", mileage: 10000, date: Date().zeroSeconds, vehicle: "vehicle3")])
    }

    func test_Shows_an_error_when_the_request_fails_when_deleting_an_invoice() async {
        givenViewModel(vehicleInvoicesGetter: SucceedingVehicleInvoicesGetter(expectedVehicleInvoices), invoiceDeletor: FailingInvoiceDeletor(withError: APICallerError.notFound))
        await whenDeletingInvoice(withId: "98YZG")
        thenError(is: APICallerError.notFound.errorDescription)
    }
    
    func test_Navigates_to_invoice_creation() {
        givenViewModel(vehicleInvoicesGetter: SucceedingVehicleInvoicesGetter(expectedVehicleInvoices))
        whenOpeningInvoiceCreationModal()
        XCTAssertTrue(isOpen)
    }

    private func givenViewModel(vehicleInvoicesGetter: VehicleInvoicesGetter,
                                invoiceDownloader: InvoiceDownloader = SucceedingInvoiceDownloader(),
                                invoiceDeletor: InvoiceDeletor = SucceedingInvoiceDeletor()) {

        viewModel = VehicleInvoiceViewModel(vehicle: vehicle,
                                            invoiceDeletor: invoiceDeletor,
                                            vehicleInvoicesGetter: vehicleInvoicesGetter,
                                            invoiceDownloader: invoiceDownloader,
                                            onNavigatingToInvoiceView: { invoice in
            self.onNavigatingToInvoiceView = true
            self.downloadedInvoice = invoice
        }, isOpeningInvoiceCreation: { _, _  in self.isOpen = true })
    }

    private func givenViewModelDeletor(invoicesGetter: VehicleInvoicesGetter, invoiceDeletor: InvoiceDeletor) {
        viewModel = VehicleInvoiceViewModel(vehicle: vehicle, invoiceDeletor: invoiceDeletor, vehicleInvoicesGetter: invoicesGetter,invoiceDownloader: SucceedingInvoiceDownloader(), onNavigatingToInvoiceView: { invoice in
            self.onNavigatingToInvoiceView = true
            self.downloadedInvoice = invoice
        }, isOpeningInvoiceCreation: {_,_  in })
    }

    private func whenDeletingInvoice(withId: String) async {
        await viewModel.deleteInvoice(idInvoice: withId)
    }

    private func whenTryingToGetVehicleInvoices() async {
        await viewModel.getInvoices()
    }

    private func whenTryingToSeeInvoice(_ invoiceId: String) async {
        await viewModel.downloadInvoiceContent(filename: invoiceId)
    }

    private func whenOpeningInvoiceCreationModal() {
        viewModel.openInvoiceCreation()
    }

    private func thenInvoicesFiles(are expected: [File]) {
//        XCTAssertEqual(expected, downloadedInvoice)
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

    private func thenError(is expected: String?) {
        XCTAssertEqual(expected, viewModel.error?.errorDescription)
    }

    private func thenLoadInvoices(are expected: [Invoice]) {
        XCTAssertEqual(expected, viewModel.invoices)
    }

    private let vehicle = Vehicle(id: "1", brand: "Brand", model: "Model", licence: "licence", type: .car, year: "year")
    private var isOpen: Bool = false
    private var viewModel: VehicleInvoiceViewModel!
    private var downloadedInvoice: File!
    private var onNavigatingToInvoiceView: Bool = false
    private let expectedVehicleInvoices = [
        Invoice(id: "0AJEAZ9", file: nil, label: "label1", mileage: 10000, date: Date().zeroSeconds, vehicle: "vehicle1"),
        Invoice(id: "0AJEAZ8", file: nil, label: "label2", mileage: 10000, date: Date().zeroSeconds, vehicle: "vehicle2"),
        Invoice(id: "0AJEAZ7", file: nil, label: "label3", mileage: 10000, date: Date().zeroSeconds, vehicle: "vehicle3")
    ]
}

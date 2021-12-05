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
        XCTAssertEqual([Invoice(id: 1, vehicle: "1", file: "1", dateCreated: "date1", dateUpdated: ""),
                        Invoice(id: 2, vehicle: "1", file: "2", dateCreated: "date2", dateUpdated: ""),
                        Invoice(id: 3, vehicle: "2", file: "3", dateCreated: "date3", dateUpdated: "")], viewModel.invoices)
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
                       invoiceFileInformationsGetter: SucceedingFileInformationsGetter(),
                       invoiceDownloader: SucceedingInvoiceDownloader())
        await whenTryingToGetVehicleInvoices()
        await whenTryingToSeeInvoice("1")
        XCTAssertTrue(onNavigatingToInvoiceView)
        XCTAssertEqual(File(title: "title", image: UIImage()), downloadedInvoice)
    }

    private func givenViewModel(vehicleInvoicesGetter: VehicleInvoicesGetter,
                                invoiceFileInformationsGetter: InvoiceFileInformationsGetter = SucceedingFileInformationsGetter(),
                                invoiceDownloader: InvoiceDownloader = SucceedingInvoiceDownloader()) {
        viewModel = VehicleInvoiceViewModel(ofVehicleId: vehicleId,
                                            vehicleInvoicesGetter: vehicleInvoicesGetter,
                                            invoiceDownloader: invoiceDownloader,
                                            invoiceFileInformationsGetter: invoiceFileInformationsGetter,
                                            onNavigatingToInvoiceView: { invoice in
            self.onNavigatingToInvoiceView = true
            self.downloadedInvoice = invoice
        })
    }

    private func whenTryingToGetVehicleInvoices() async {
        await viewModel.getInvoices(ofVehicleId: vehicleId)
    }

    private func whenTryingToSeeInvoice(_ invoiceId: String) async {
        await viewModel.downloadInvoiceContent(of: invoiceId)
    }

    private func thenViewModelIsLoading() {
        XCTAssertTrue(viewModel.isLoading)
    }

    private func thenViewModelIsNotLoading() {
        XCTAssertFalse(viewModel.isLoading)
    }

    private func thenError(is expected: String) {
        XCTAssertEqual(expected, viewModel.error?.errorDescription)
    }

    private var viewModel: VehicleInvoiceViewModel!
    private var vehicleId: String = "1"
    private var downloadedInvoice: File!
    private var onNavigatingToInvoiceView: Bool = false
    private let expectedVehicleInvoices = [
        Invoice(id: 1, vehicle: "1", file: "1", dateCreated: "date1", dateUpdated: ""),
        Invoice(id: 2, vehicle: "1", file: "2", dateCreated: "date2", dateUpdated: ""),
        Invoice(id: 3, vehicle: "2", file: "3", dateCreated: "date3", dateUpdated: "")]
}

class SucceedingVehicleInvoicesGetter: VehicleInvoicesGetter {

    private var invoices: [Invoice]

    init(_ invoices: [Invoice]) {
        self.invoices = invoices
    }

    func getInvoices(ofVehicleId: String) async throws -> [Invoice] {
        return invoices
    }
    
}

class FailingVehicleInvoicesGetter: VehicleInvoicesGetter {

    private var error: APICallerError

    init(withError error: APICallerError) {
        self.error = error
    }

    func getInvoices(ofVehicleId: String) async throws -> [Invoice] {
        throw error
    }

}

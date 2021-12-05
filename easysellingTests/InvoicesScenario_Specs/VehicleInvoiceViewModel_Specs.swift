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
        let expectedVehicleInvoices = [Invoice(id: 1, vehicle: "1", file: "1", dateCreated: "date1", dateUpdated: ""),
                                           Invoice(id: 2, vehicle: "1", file: "2", dateCreated: "date2", dateUpdated: ""),
                                           Invoice(id: 3, vehicle: "2", file: "3", dateCreated: "date3", dateUpdated: "")]
        givenViewModel(vehicleInvoicesGetter: SucceedingVehicleInvoicesGetter(expectedVehicleInvoices))
        thenViewModelIsLoading()
        await whenTryingToGetVehicleInvoices()
        thenViewModelIsNotLoading()
    }

    func test_Shows_error_when_request_is_failing() async {
        givenViewModel(vehicleInvoicesGetter: FailingVehicleInvoicesGetter(withError: APICallerError.notFound))
        thenViewModelIsLoading()
        await whenTryingToGetVehicleInvoices()
        thenError(is: "Impossible de trouver ce que vous cherchez")
        thenViewModelIsNotLoading()
    }

    private func givenViewModel(vehicleInvoicesGetter: VehicleInvoicesGetter) {
        viewModel = VehicleInvoiceViewModel(vehicleInvoicesGetter: vehicleInvoicesGetter, ofVehicleId: vehicleId)
    }

    private func whenTryingToGetVehicleInvoices() async {
        await viewModel.getInvoices(ofVehicleId: vehicleId)
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

}

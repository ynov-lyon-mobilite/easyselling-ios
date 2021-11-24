//
//  VehicleUpdateViewModel_specs.swift
//  easysellingTests
//
//  Created by Pierre Gourgouillon on 21/11/2021.
//

import XCTest
@testable import easyselling

class VehicleUpdateViewModel_specs: XCTestCase {

    private var isDelete: Bool!
    private var viewModel: VehicleUpdateViewModel!

    func test_Shows_alert_when_brand_is_Empty() async {
        givenViewModel(expected: .emptyField)
        await whenUpdating()
        thenAlertMessage(expected: VehicleCreationError.emptyField.description)
        thenAlertIsShowing()
    }

    func test_Shows_alert_when_year_is_incorrect() async {
        givenViewModel(expected: .incorrectYear)
        await whenUpdating()
        thenAlertMessage(expected: VehicleCreationError.incorrectYear.description)
        thenAlertIsShowing()
    }

    func test_Shows_alert_when_license_is_incorrect() async {
        givenViewModel(expected: .incorrectLicense)
        await whenUpdating()
        thenAlertMessage(expected: VehicleCreationError.incorrectLicense.description)
        thenAlertIsShowing()
    }

    func test_Shows_alert_when_an_error_happens_after_an_api_call() async {
        givenViewModel()
        await whenUpdating()
        thenAlertIsShowing()
    }

    func test_modifies_the_existing_vehicle() async {
        givenViewModel()
        await whenUpdateSuccesfull()
        thenModalIsDelete()
    }
    
    private func givenViewModel(expected: VehicleCreationError = .emptyField) {
        viewModel = VehicleUpdateViewModel(vehicle: Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"), onFinish: {
            self.isDelete = true
        }, vehicleVerificator: SpyVehicleInformationsVerificator(error: expected), vehicleUpdater: DefaultVehicleUpdater())
    }

    private func whenUpdating() async{
        await viewModel.updateVehicle()
    }

    private func whenUpdateSuccesfull() async {
        await viewModel.deleteModal()
    }

    private func thenAlertMessage(expected: String) {
        XCTAssertEqual(expected, viewModel.alert)
    }
    private func thenAlertIsShowing() {
        XCTAssertTrue(viewModel.showAlert)
    }

    private func thenModalIsDelete() {
        XCTAssertTrue(isDelete)
    }
}

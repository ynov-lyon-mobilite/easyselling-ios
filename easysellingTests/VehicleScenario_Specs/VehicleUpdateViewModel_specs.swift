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
        givenViewModel(expected: .emptyField, vehicle:
                        Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"))
        await whenUpdating()
        thenAlertMessage(is: "A field is empty")
        thenAlertIsShowing()
    }

    func test_Shows_alert_when_year_is_incorrect() async {
        givenViewModel(expected: .incorrectYear, vehicle:
                        Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"))
        await whenUpdating()
        thenAlertMessage(is: "The year format is incorrect")
        thenAlertIsShowing()
    }

    func test_Shows_alert_when_license_is_incorrect() async {
        givenViewModel(expected: .incorrectLicense, vehicle:
                        Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"))
        await whenUpdating()
        thenAlertMessage(is: "The license format is incorrect")
        thenAlertIsShowing()
    }

    func test_modifies_the_vehicle() async {
        givenViewModel(vehicle: Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1"))
        await whenUpdateSucceed()
        thenModalIsDelete()
    }
    
    private func givenViewModel(expected: VehicleCreationError = .emptyField, vehicle: Vehicle) {
        viewModel = VehicleUpdateViewModel(vehicle: vehicle, onFinish: {
            self.isDelete = true
        }, vehicleVerificator: SpyVehicleInformationsVerificator(error: expected), vehicleUpdater: DefaultVehicleUpdater())
    }

    private func whenUpdating() async{
        await viewModel.updateVehicle()
    }

    private func whenUpdateSucceed() async {
        await viewModel.onFinish()
    }

    private func thenAlertMessage(is expected: String) {
        XCTAssertEqual(expected, viewModel.alert)
    }
    private func thenAlertIsShowing() {
        XCTAssertTrue(viewModel.showAlert)
    }

    private func thenModalIsDelete() {
        XCTAssertTrue(isDelete)
    }
}

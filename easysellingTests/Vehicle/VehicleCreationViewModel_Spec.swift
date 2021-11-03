//
//  VehicleCreationViewModel_Spec.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import XCTest
@testable import easyselling

class VehicleCreationViewModel_Spec: XCTestCase {
    
    private var isCreated: Bool!
    private var viewModel: VehicleCreationViewModel!
    
    func test_Leaves_vehicle_creation_on_vehicle_informations_submit() async {
        givenViewModel()
        await viewModel.createVehicle()
        XCTAssertTrue(isCreated)
    }
    
    func test_Shows_alert_when_a_field_is_empty() async {
        givenViewModel(exepected: .emptyField)
        await whenCreating()
        thenAlert(expected: .emptyField)
    }
    
    func test_Shows_alert_when_the_field_year_is_incorrect() async {
        givenViewModel(exepected: .wrongYear)
        await whenCreating()
        thenAlert(expected: .wrongYear)
    }
    
    func test_Shows_alert_when_the_field_license_is_incorrect() async {
        givenViewModel(exepected: .wrongLicenseNumber)
        await whenCreating()
        thenAlert(expected: .wrongLicenseNumber)
    }
    
    func test_Shows_alert_when_an_error_happens_after_a_call_api() async {
        givenViewModel(throwError: true)
        await whenCreating()
        XCTAssertTrue(viewModel.showAlert)
    }
    
    func test_Verifies_alert_is_hide() async {
        givenViewModel()
        await whenCreating()
        XCTAssertFalse(viewModel.showAlert)
    }

    private func givenViewModel(exepected: VehicleCreationError? = nil, throwError: Bool = false) {
        viewModel = VehicleCreationViewModel(vehicleCreator: SpyVehicleCreator(throwError: throwError), vehicleVerificator: SpyVehicleInformationsVerificator(status: exepected), onFinish: {
            self.isCreated = true
        })
    }

    private func whenCreating() async {
        await viewModel.createVehicle()
    }

    private func thenAlert(expected: VehicleCreationError) {
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(expected.errorDescription, viewModel.alertText)
    }
}

class SpyVehicleCreator: VehicleCreatorProtocol {
    
    private var throwError: Bool
    
    init(throwError: Bool) {
        self.throwError = throwError
    }
    
    func createVehicle(informations: VehicleInformations) async throws {
        if throwError {
            throw APICallerError.internalServerError
        }
    }
}

class SpyVehicleInformationsVerificator: VehicleInformationsProtocol {
    
    private let status: VehicleCreationError?
    
    init(status: VehicleCreationError?) {
        self.status = status
    }
    
    func checkingInformations(vehicle: VehicleInformations) -> VehicleCreationError? {
        return status
    }
}

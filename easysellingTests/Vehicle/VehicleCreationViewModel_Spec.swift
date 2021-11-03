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
    
    func test_Leaves_vehicle_creation_on_vehicle_informations_submit() {
        givenViewModel()
        whenCreationSuccessful()
        XCTAssertTrue(isCreated)
    }
    
    func test_Shows_alert_when_a_field_is_empty() async {
        givenViewModel(exepected: .emptyField)
        await whenCreating()
        thenAlert(expected: VehicleCreationError.emptyField.errorDescription ?? "")
    }
    
    func test_Shows_alert_when_the_field_year_is_incorrect() async {
        givenViewModel(exepected: .incorrectYear)
        await whenCreating()
        thenAlert(expected: VehicleCreationError.incorrectYear.errorDescription ?? "")
    }
    
    func test_Shows_alert_when_the_field_license_is_incorrect() async {
        givenViewModel(exepected: .incorrectLicense)
        await whenCreating()
        thenAlert(expected: VehicleCreationError.incorrectLicense.errorDescription ?? "")
    }
    
    func test_Shows_alert_when_an_error_happens_after_a_call_api() async {
        givenViewModel(throwError: true)
        await whenCreating()
        XCTAssertTrue(viewModel.showAlert)
    }
    
    func test_Shows_alert_when_the_creation_have_successful() async {
        givenViewModel()
        await whenCreating()
        thenAlert(expected: L10n.CreateVehicle.creationSuccessful)
    }

    private func givenViewModel(exepected: VehicleCreationError? = nil, throwError: Bool = false) {
        viewModel = VehicleCreationViewModel(vehicleCreator: SpyVehicleCreator(throwError: throwError), vehicleVerificator: SpyVehicleInformationsVerificator(error: exepected), onFinish: {
            self.isCreated = true
        })
    }

    private func whenCreating() async {
        await viewModel.createVehicle()
    }
    
    private func whenCreationSuccessful() {
        viewModel.dismissModal()
    }

    private func thenAlert(expected: String) {
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(expected, viewModel.alert)
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
    
    private let error: VehicleCreationError?
    
    init(error: VehicleCreationError?) {
        self.error = error
    }
    
    func verifyInformations(vehicle: VehicleInformations) -> VehicleCreationError? {
        return error
    }
}

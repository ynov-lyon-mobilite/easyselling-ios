//
//  VehicleCreationViewModel_Spec.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import XCTest
@testable import easyselling

class VehicleCreationViewModel_Specs: XCTestCase {
    
    private var isDismissed: Bool!
    private var viewModel: VehicleCreationViewModel!
    
    func test_Shows_alert_when_a_field_is_empty() async {
        givenViewModel(exepected: .emptyField)
        await whenCreating()
        thenAlertMessage(expected: VehicleCreationError.emptyField.errorDescription)
        thenAlertIsShowing()
    }
    
    func test_Shows_alert_when_the_field_year_is_incorrect() async {
        givenViewModel(exepected: .incorrectYear)
        await whenCreating()
        thenAlertMessage(expected: VehicleCreationError.incorrectYear.errorDescription)
        thenAlertIsShowing()
    }
    
    func test_Shows_alert_when_the_field_license_is_incorrect() async {
        givenViewModel(exepected: .incorrectLicense)
        await whenCreating()
        thenAlertMessage(expected: VehicleCreationError.incorrectLicense.errorDescription)
        thenAlertIsShowing()
    }
    
    func test_Shows_alert_when_an_error_happens_after_an_api_call() async {
        givenViewModel(throwError: true)
        await whenCreating()
        thenAlertIsShowing()
    }
    
    func test_Shows_alert_when_the_creation_have_successful() async {
        givenViewModel()
        await whenCreating()
        thenAlertMessage(expected: L10n.CreateVehicle.creationSuccessful)
        thenAlertIsShowing()
    }
    
    func test_Dismisses_modal_when_the_creation_have_successful() {
        givenViewModel()
        whenCreationSuccessful()
        thenModalIsDismissed()
    }

    private func givenViewModel(exepected: VehicleCreationError? = nil, throwError: Bool = false) {
        viewModel = VehicleCreationViewModel(vehicleCreator: SpyVehicleCreator(throwError: throwError), vehicleVerificator: SpyVehicleInformationsVerificator(error: exepected), onFinish: {
            self.isDismissed = true
        })
    }

    private func whenCreating() async {
        await viewModel.createVehicle()
    }
    
    private func whenCreationSuccessful() {
        viewModel.dismissModal()
    }

    private func thenAlertIsShowing() {
        XCTAssertTrue(viewModel.showAlert)
    }
    
    private func thenAlertMessage(expected: String) {
        XCTAssertEqual(expected, viewModel.alert)
    }
    
    private func thenModalIsDismissed() {
        XCTAssertTrue(isDismissed)
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

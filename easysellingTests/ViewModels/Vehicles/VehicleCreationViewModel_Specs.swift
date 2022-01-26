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
        givenViewModel(expected: .emptyField)
        await whenCreating()
        thenAlertMessage(expected: VehicleCreationError.emptyField.description)
        thenAlertIsShowing()
    }
    
    func test_Shows_alert_when_the_field_year_is_incorrect() async {
        givenViewModel(expected: .incorrectYear)
        await whenCreating()
        thenAlertMessage(expected: VehicleCreationError.incorrectYear.description)
        thenAlertIsShowing()
    }
    
    func test_Shows_alert_when_the_field_license_is_incorrect() async {
        givenViewModel(expected: .incorrectLicenseFormat)
        await whenCreating()
        thenAlertMessage(expected: VehicleCreationError.incorrectLicenseFormat.description)
        thenAlertIsShowing()
    }
    
    func test_Shows_alert_when_an_error_happens_after_an_api_call() async {
        givenViewModel()
        await whenCreating()
        thenAlertIsShowing()
    }
    
    func test_Dismisses_modal_when_the_creation_have_successful() async {
        givenViewModel()
        await whenCreationSuccessful()
        thenModalIsDismissed()
    }

    private func givenViewModel(expected: VehicleCreationError = .emptyField) {
        viewModel = VehicleCreationViewModel(vehicleCreator: SpyVehicleCreator(), vehicleVerificator: SpyVehicleInformationsVerificator(error: expected), onFinish: {
            self.isDismissed = true
        })
    }

    private func whenCreating() async {
        await viewModel.createVehicle()
    }
    
    private func whenCreationSuccessful() async {
        await viewModel.dismissModal()
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

class SpyVehicleCreator: VehicleCreator {
    
    func createVehicle(informations: Vehicle) async throws {
        throw APICallerError.internalServerError
    }
}

class SpyVehicleInformationsVerificator: VehicleInformationsVerificator {
    
    private let error: VehicleCreationError
    
    init(error: VehicleCreationError) {
        self.error = error
    }

    func verifyInformations(vehicle: Vehicle) throws {
        throw error
    }
}
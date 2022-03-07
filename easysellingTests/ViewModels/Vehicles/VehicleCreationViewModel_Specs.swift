//
//  VehicleCreationViewModel_Spec.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import XCTest
@testable import easyselling

class VehicleCreationViewModel_Specs: XCTestCase {

    func test_Updates_title_for_vehicle_creation_step() {
        givenViewModel()
        thenTitle(is: "Mon type de véhicule")
        viewModel.vehicleCreationStep = .licence
        thenTitle(is: "Ma plaque d'immatriculation")
        viewModel.vehicleCreationStep = .brandAndModel
        thenTitle(is: "Marque et modèle")
        viewModel.vehicleCreationStep = .year
        thenTitle(is: "Année d'immatriculation")
    }

    func test_Keeps_vehicle_creation_when_vehicle_type_is_correct() {
        givenViewModel()
        thenActualStep(is: .vehicleType)
        whenSelectingVehicleType(.car)
        XCTAssertEqual(.car, viewModel.type)
        XCTAssertEqual(.car, viewModel.createdVehicle.type)
        XCTAssertEqual(.licence, viewModel.vehicleCreationStep)
    }

    func test_Keeps_vehicle_creation_when_licence_is_correct() {
        givenViewModel(vehicleInformationsVerificator: SucceedingVehicleInformationsVerificator())
        whenSelectingVehicleType(.car)
        thenActualStep(is: .licence)
        whenSelectingLicence("AA-222-AA")
        XCTAssertEqual("AA-222-AA", viewModel.license)
        XCTAssertEqual("AA-222-AA", viewModel.createdVehicle.license)
        thenActualStep(is: .brandAndModel)
    }

    func test_Continues_vehicle_creation_when_brand_and_model_are_corrects() {
        givenViewModel(vehicleInformationsVerificator: SucceedingVehicleInformationsVerificator())
        whenSelectingVehicleType(.car)
        XCTAssertEqual(.licence, viewModel.vehicleCreationStep)
        whenSelectingLicence("AA-222-AA")
        XCTAssertEqual(.brandAndModel, viewModel.vehicleCreationStep)
        whenSelectingBrandAndModel("Peugeot", "206")
        XCTAssertEqual("Peugeot", viewModel.brand)
        XCTAssertEqual("Peugeot", viewModel.createdVehicle.brand)
        XCTAssertEqual("206", viewModel.model)
        XCTAssertEqual("206", viewModel.createdVehicle.model)
        XCTAssertEqual(.year, viewModel.vehicleCreationStep)
    }

    func test_Shows_error_when_user_hasnt_choose_a_vehicle_type() {
        givenViewModel()
        thenActualStep(is: .vehicleType)
        whenSelectingVehicleType(.unknow)
        thenActualStep(is: .vehicleType)
        thenError(is: .unchosenType)
    }

    func test_Shows_error_when_user_has_write_invalid_licence() {
        givenViewModel(vehicleInformationsVerificator: FailingVehicleInformationsVerificator(error: .incorrectLicenseFormat))
        whenSelectingVehicleType(.car)
        thenActualStep(is: .licence)
        whenSelectingLicence("invalid")
        thenError(is: .incorrectLicenseFormat)
    }

    func test_Returns_back_if_user_has_made_something_wrong() {
        givenViewModel(vehicleInformationsVerificator: SucceedingVehicleInformationsVerificator())
        thenActualStep(is: .vehicleType)
        whenSelectingVehicleType(.car)
        thenActualStep(is: .licence)
        whenGoingBack()
        thenActualStep(is: .vehicleType)
    }

    private func whenGoingBack() {
        viewModel.goingToPrevious()
    }

    private func whenSelectingVehicleType(_ vehicleType: Vehicle.Category) {
        viewModel.type = vehicleType
        whenContinueVehicleCreation()
    }

    private func whenSelectingLicence(_ licence: String) {
        viewModel.license = licence
        whenContinueVehicleCreation()
    }

    private func whenSelectingBrandAndModel(_ brand: String, _ model: String) {
        viewModel.brand = brand
        viewModel.model = model
        whenContinueVehicleCreation()
    }
    
    private func whenContinueVehicleCreation() {
        viewModel.continueVehicleCreation()
    }
    
    func test_Dismisses_modal_when_the_creation_have_successful() async {
        givenViewModel()
        await whenCreationSuccessful()
//        thenModalIsDismissed()
    }

    private func givenViewModel(vehicleInformationsVerificator: VehicleInformationsVerificator = FailingVehicleInformationsVerificator(error: .emptyField)) {
        viewModel = VehicleCreationViewModel(vehicleCreator: SpyVehicleCreator(), vehicleVerificator: vehicleInformationsVerificator, isOpenningVehicleCreation: .constant(true))
    }

    private func whenCreating() async {
//        await viewModel.createVehicle()
    }
    
    private func whenCreationSuccessful() async {
        await viewModel.dismissModal()
    }

    private func thenAlertIsShowing() {
        XCTAssertTrue(viewModel.showAlert)
    }

    private func thenActualStep(is expected: VehicleCreationViewModel.VehicleCreationStep) {
        XCTAssertEqual(expected, viewModel.vehicleCreationStep)
    }

    private func thenTitle(is expected: String) {
        XCTAssertEqual(expected, viewModel.title)
    }

    private func thenError(is expected: VehicleCreationError) {
        XCTAssertEqual(expected.errorDescription, viewModel.error?.errorDescription)
    }

    private var viewModel: VehicleCreationViewModel!
}

class SpyVehicleCreator: VehicleCreator {
    
    func createVehicle(informations: VehicleDTO) async throws {
        throw APICallerError.internalServerError
    }
}

class FailingVehicleInformationsVerificator: VehicleInformationsVerificator {
    
    private let error: VehicleCreationError
    
    init(error: VehicleCreationError) {
        self.error = error
    }

    func verifyInformations(vehicle: VehicleDTO) throws {
        throw error
    }

    func verifyLicence(_ licence: String) throws {
        throw error
    }
}

class SucceedingVehicleInformationsVerificator: VehicleInformationsVerificator {

    func verifyInformations(vehicle: Vehicle) throws {
        return
    }

    func verifyLicence(_ licence: String) throws {
        return
    }
}

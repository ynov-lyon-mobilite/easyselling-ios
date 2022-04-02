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
        thenTitle(is: "My vehicle type")
        viewModel.vehicleCreationStep = .licence
        thenTitle(is: "My licence plate")
        viewModel.vehicleCreationStep = .brandAndModel
        thenTitle(is: "Brand and model")
        viewModel.vehicleCreationStep = .year
        thenTitle(is: "Year of registration")
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
        XCTAssertEqual("AA-222-AA", viewModel.licence)
        XCTAssertEqual("AA-222-AA", viewModel.createdVehicle.licence)
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
        givenViewModel(vehicleInformationsVerificator: FailingVehicleInformationsVerificator(error: .incorrectlicenceFormat))
        whenSelectingVehicleType(.car)
        thenActualStep(is: .licence)
        whenSelectingLicence("invalid")
        thenError(is: .incorrectlicenceFormat)
    }

    func test_Returns_back_if_user_has_made_something_wrong() {
        givenViewModel(vehicleInformationsVerificator: SucceedingVehicleInformationsVerificator())
        thenActualStep(is: .vehicleType)
        whenSelectingVehicleType(.car)
        thenActualStep(is: .licence)
        whenGoingBack()
        thenActualStep(is: .vehicleType)
    }

    func test_Dismiss_modal_when_user_has_finished_create_vehicle_without_error() async {
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
        await whenCreatingVehicle()
        ThenVehicleCreationHasFinish()
    }

    func test_show_error_when_vehicle_creation_fail() async {
        givenViewModel(vehicleCreator: FailingVehicleCreator(error: .forbidden), vehicleInformationsVerificator: SucceedingVehicleInformationsVerificator())
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
        await whenCreatingVehicle()
        thenError(is: .forbidden)
    }

    private func whenGoingBack() {
        viewModel.goingToPrevious()
    }

    private func whenSelectingVehicleType(_ vehicleType: Vehicle.Category) {
        viewModel.type = vehicleType
        whenContinueVehicleCreation()
    }

    private func whenSelectingLicence(_ licence: String) {
        viewModel.licence = licence
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

    private func givenViewModel(vehicleCreator: VehicleCreator = SucceedingVehicleCreator(), vehicleInformationsVerificator: VehicleInformationsVerificator = FailingVehicleInformationsVerificator(error: .emptyField)) {
        
        viewModel = VehicleCreationViewModel(vehicleCreator: vehicleCreator, vehicleVerificator: vehicleInformationsVerificator, hasFinishedVehicleCreation: {
            self.hasCreatedVehicle = true
        })
    }

    private func whenCreatingVehicle() async {
        await viewModel.createVehicle()
    }
    
    private func whenCreationSuccessful() {
        viewModel.dismissModal()
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

    private func thenError(is expected: APICallerError) {
        XCTAssertEqual(expected.errorDescription, viewModel.error?.errorDescription)
    }

    private func ThenVehicleCreationHasFinish() {
        XCTAssertTrue(hasCreatedVehicle)
    }

    private var viewModel: VehicleCreationViewModel!
    private var hasCreatedVehicle: Bool = false
}

class FailingVehicleCreator: VehicleCreator {

    init(error: APICallerError) {
        self.error = error
    }

    private var error: APICallerError

    func createVehicle(informations: VehicleDTO) async throws {
        throw error
    }
}

class SucceedingVehicleCreator: VehicleCreator {
    func createVehicle(informations: VehicleDTO) async throws {
        return
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

    func verifyInformations(vehicle: VehicleDTO) throws {
        return
    }

    func verifyLicence(_ licence: String) throws {
        return
    }
}

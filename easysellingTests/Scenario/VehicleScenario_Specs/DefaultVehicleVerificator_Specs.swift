//
//  DefaultVehicleVerificator_Specs.swift
//  easysellingTests
//
//  Created by Valentin Mont School on 27/11/2021.
//

import XCTest
@testable import easyselling

class DefaultVehicleVerificator_Specs: XCTestCase {

    func test_Verifies_if_the_licence_has_a_correct_format_for_old_licence() {
        givenVerificator()
        whenCheckinglicenceFormat(licence: "524 WAL 75")
        thenNoErrorThrows()
    }

    func test_Verifies_if_the_licence_has_a_correct_format_for_new_licence() {
        givenVerificator()
        whenCheckinglicenceFormat(licence: "AE-452-BD")
        thenNoErrorThrows()
    }

    func test_Verifies_if_the_licence_has_an_incorrect_format_for_old_licence() {
        givenVerificator()
        whenCheckinglicenceFormat(licence: "524 WALA75")
        thenError(is: .incorrectlicenceFormat)
    }

    func test_Verifies_if_the_licence_has_an_incorrect_format_for_new_licence() {
        givenVerificator()
        whenCheckinglicenceFormat(licence: "AE-452BBD")
        thenError(is: .incorrectlicenceFormat)
    }

    func test_Verifies_if_licence_has_a_correct_size_for_old_licence() {
        givenVerificator()
        whenCheckinglicenceSize(licence: "524 WAL 75")
        thenNoErrorThrows()
    }

    func test_Verifies_if_licence_has_a_correct_size_for_new_licence() {
        givenVerificator()
        whenCheckinglicenceSize(licence: "AE-452-BD")
        thenNoErrorThrows()
    }

    func test_Verifies_if_licence_has_an_incorrect_size_for_old_licence() {
        givenVerificator()
        whenCheckinglicenceSize(licence: "524 WAL 755")
        thenError(is: .incorrectlicenceSize)
    }

    func test_Verifies_if_licence_has_an_incorrect_size_for_new_licence() {
        givenVerificator()
        whenCheckinglicenceSize(licence: "AE-452-BDF")
        thenError(is: .incorrectlicenceSize)
    }

    private func givenVerificator() {
        verificator = DefaultVehicleVerificator()
    }

    private func whenCheckinglicenceFormat(licence: String) {
        do {
            try verificator.verifylicenceFormat(licence: licence)
        } catch (let error) {
            self.vehicleCreationError = (error as! VehicleCreationError)
        }
    }

    private func whenCheckinglicenceSize(licence: String) {
        do {
            try verificator.verifylicenceSize(licence: licence)
        } catch (let error) {
            self.vehicleCreationError = (error as! VehicleCreationError)
        }
    }

    private func thenNoErrorThrows() {
        XCTAssertNil(vehicleCreationError)
    }

    private func thenError(is expected: VehicleCreationError) {
        XCTAssertEqual(expected.errorDescription, vehicleCreationError.errorDescription)
        XCTAssertEqual(expected, vehicleCreationError)
    }

    private var verificator: VehicleVerificator!
    private var vehicleCreationError: VehicleCreationError!
}

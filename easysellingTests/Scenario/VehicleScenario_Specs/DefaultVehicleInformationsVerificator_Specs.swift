//
//  VehicleInformationsVerificator_Specs.swift
//  easysellingTests
//
//  Created by Valentin Mont School on 07/11/2021.
//

import XCTest
@testable import easyselling

class DefaultVehicleInformationsVerificator_Specs: XCTestCase {

    func test_Throws_error_if_licence_has_an_incorrect_licence_format() {
        givenVerificator()
        whenCheckinglicence("AA-2B2-AA")
        thenError(is: .incorrectlicenceFormat)
    }

    func test_Throws_error_if_licence_has_an_incorrect_licence_format2() {
        givenVerificator()
        whenCheckinglicence("524 WAL 7A")
        thenError(is: .incorrectlicenceFormat)
    }

    func test_Throws_error_if_licence_has_an_incorrect_licence_size() {
        givenVerificator()
        whenCheckinglicence("AA-222-AAA")
        thenError(is: .incorrectlicenceSize)
    }

    func test_Throws_error_if_licence_has_an_incorrect_licence_size2() {
        givenVerificator()
        whenCheckinglicence("524 WAL 7")
        thenError(is: .incorrectlicenceSize)
    }

    func test_Verifies_licence_has_a_correct_format() {
        givenVerificator()
        whenCheckinglicence("AA-222-AA")
        thenNoErrorThrows()
    }

    func test_Verifies_licence_has_a_correct_format2() {
        givenVerificator()
        whenCheckinglicence("524 WAL 75")
        thenNoErrorThrows()
    }

    private func givenVerificator() {
        verificator = DefaultVehicleInformationsVerificator()
    }
    
    private func whenChecking(vehicle: VehicleDTO) {
        do {
            try verificator.verifyInformations(vehicle: vehicle)
        } catch (let error) {
            self.vehicleCreationError = (error as! VehicleCreationError)
        }
    }

    private func whenCheckinglicence(_ licence: String) {
        do {
            try verificator.verifylicence(licence)
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

    private var verificator: VehicleInformationsVerificator!
    private var vehicleCreationError: VehicleCreationError!
}

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
        whenCheckingLicence("AA-2B2-AA")
        thenError(is: .incorrectLicenseFormat)
    }

    func test_Throws_error_if_licence_has_an_incorrect_licence_format2() {
        givenVerificator()
        whenCheckingLicence("524 WAL 7A")
        thenError(is: .incorrectLicenseFormat)
    }

    func test_Throws_error_if_licence_has_an_incorrect_licence_size() {
        givenVerificator()
        whenCheckingLicence("AA-222-AAA")
        thenError(is: .incorrectLicenseSize)
    }

    func test_Throws_error_if_licence_has_an_incorrect_licence_size2() {
        givenVerificator()
        whenCheckingLicence("524 WAL 7")
        thenError(is: .incorrectLicenseSize)
    }

    func test_Verifies_license_has_a_correct_format() {
        givenVerificator()
        whenCheckingLicence("AA-222-AA")
        thenNoErrorThrows()
    }

    func test_Verifies_license_has_a_correct_format2() {
        givenVerificator()
        whenCheckingLicence("524 WAL 75")
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

    private func whenCheckingLicence(_ licence: String) {
        do {
            try verificator.verifyLicence(licence)
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

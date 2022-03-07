//
//  DefaultVehicleVerificator_Specs.swift
//  easysellingTests
//
//  Created by Valentin Mont School on 27/11/2021.
//

import XCTest
@testable import easyselling

class DefaultVehicleVerificator_Specs: XCTestCase {

    func test_Verifies_if_the_licence_has_a_correct_format_for_old_license() {
        givenVerificator()
        whenCheckingLicenseFormat(license: "524 WAL 75")
        thenNoErrorThrows()
    }

    func test_Verifies_if_the_licence_has_a_correct_format_for_new_license() {
        givenVerificator()
        whenCheckingLicenseFormat(license: "AE-452-BD")
        thenNoErrorThrows()
    }

    func test_Verifies_if_the_licence_has_an_incorrect_format_for_old_license() {
        givenVerificator()
        whenCheckingLicenseFormat(license: "524 WALA75")
        thenError(is: .incorrectLicenseFormat)
    }

    func test_Verifies_if_the_licence_has_an_incorrect_format_for_new_license() {
        givenVerificator()
        whenCheckingLicenseFormat(license: "AE-452BBD")
        thenError(is: .incorrectLicenseFormat)
    }

    func test_Verifies_if_license_has_a_correct_size_for_old_license() {
        givenVerificator()
        whenCheckingLicenseSize(licence: "524 WAL 75")
        thenNoErrorThrows()
    }

    func test_Verifies_if_license_has_a_correct_size_for_new_license() {
        givenVerificator()
        whenCheckingLicenseSize(licence: "AE-452-BD")
        thenNoErrorThrows()
    }

    func test_Verifies_if_license_has_an_incorrect_size_for_old_license() {
        givenVerificator()
        whenCheckingLicenseSize(licence: "524 WAL 755")
        thenError(is: .incorrectLicenseSize)
    }

    func test_Verifies_if_license_has_an_incorrect_size_for_new_license() {
        givenVerificator()
        whenCheckingLicenseSize(licence: "AE-452-BDF")
        thenError(is: .incorrectLicenseSize)
    }

    private func givenVerificator() {
        verificator = DefaultVehicleVerificator()
    }

    private func whenCheckingLicenseFormat(license: String) {
        do {
            try verificator.verifyLicenseFormat(license: license)
        } catch (let error) {
            self.vehicleCreationError = (error as! VehicleCreationError)
        }
    }

    private func whenCheckingLicenseSize(licence: String) {
        do {
            try verificator.verifyLicenseSize(license: licence)
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

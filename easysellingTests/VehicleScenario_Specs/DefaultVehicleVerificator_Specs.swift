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
        thenVerificationHasSuccess(expected: false)
    }

    func test_Verifies_if_the_licence_has_a_correct_format_for_new_license() {
        givenVerificator()
        whenCheckingLicenseFormat(license: "AE-452-BD")
        thenVerificationHasSuccess(expected: false)
    }

    func test_Verifies_if_the_licence_has_an_incorrect_format_for_old_license() {
        givenVerificator()
        whenCheckingLicenseFormat(license: "524 WAL75")
        thenVerificationHasSuccess(expected: true)
    }

    func test_Verifies_if_the_licence_has_an_incorrect_format_for_new_license() {
        givenVerificator()
        whenCheckingLicenseFormat(license: "AE-452BD")
        thenVerificationHasSuccess(expected: true)
    }

    func test_Verifies_if_license_has_a_correct_size_for_old_license() {
        givenVerificator()
        whenCheckingLicenseSize(licence: "524 WAL 75")
        thenVerificationHasSuccess(expected: false)
    }

    func test_Verifies_if_license_has_a_correct_size_for_new_license() {
        givenVerificator()
        whenCheckingLicenseSize(licence: "AE-452-BD")
        thenVerificationHasSuccess(expected: false)
    }

    func test_Verifies_if_license_has_an_incorrect_size_for_old_license() {
        givenVerificator()
        whenCheckingLicenseSize(licence: "524 WAL 755")
        thenVerificationHasSuccess(expected: true)
    }

    func test_Verifies_if_license_has_an_incorrect_size_for_new_license() {
        givenVerificator()
        whenCheckingLicenseSize(licence: "AE-452-BDF")
        thenVerificationHasSuccess(expected: true)
    }

    private func givenVerificator() {
        verificator = DefaultVehicleVerificator()
    }

    private func whenCheckingLicenseFormat(license: String) {
        verificationResult = verificator.verifyLicenseFormat(license: license)
    }

    private func whenCheckingLicenseSize(licence: String) {
        verificationResult = verificator.verifyLicenseSize(license: licence)
    }

    private func thenVerificationHasSuccess(expected: Bool) {
        XCTAssertEqual(expected, verificationResult)
    }

    private var verificator: VehicleVerificator!
    private var verificationResult: Bool!
}

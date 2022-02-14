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

    func test_Verfies_message_when_license_is_empty() {
        givenVerificator()
        whenChecking(vehicle: Vehicle(brand: "brand", model: "model", license: "", type: Vehicle.Category.car, year: "year"))
        thenError(is: .emptyField)
    }
    
    func test_Verfies_message_when_brand_is_empty() {
        givenVerificator()
        whenChecking(vehicle: Vehicle(brand: "", model: "model", license: "123456789", type: Vehicle.Category.car, year: "year"))
        thenError(is: .emptyField)
    }
    
    func test_Verfies_message_when_model_is_empty() {
        givenVerificator()
        whenChecking(vehicle: Vehicle(brand: "brand", model: "", license: "123456789", type: Vehicle.Category.car, year: "year"))
        thenError(is: .emptyField)
    }
    
    func test_Verifies_message_if_year_has_an_incorrect_format() {
        givenVerificator()
        whenChecking(vehicle: Vehicle(brand: "brand", model: "model", license: "AA-222-AA", type: Vehicle.Category.car, year: "222"))
        thenError(is: .incorrectYear)
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
        XCTAssertEqual(expected.description, vehicleCreationError.description)
        XCTAssertEqual(expected, vehicleCreationError)
    }

    private var verificator: VehicleInformationsVerificator!
    private var vehicleCreationError: VehicleCreationError!
}

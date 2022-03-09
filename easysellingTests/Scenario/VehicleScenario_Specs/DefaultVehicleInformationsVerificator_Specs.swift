//
//  VehicleInformationsVerificator_Specs.swift
//  easysellingTests
//
//  Created by Valentin Mont School on 07/11/2021.
//

import XCTest
@testable import easyselling

class DefaultVehicleInformationsVerificator_Specs: XCTestCase {
    
    func test_Verfies_message_when_license_is_empty() {
        givenVerificator()
        whenChecking(vehicle: VehicleDTO(brand: "brand", license: "", model: "model", type: Vehicle.Category.car.rawValue, year: "year"))
        thenError(is: .emptyField)
    }
    
    func test_Verfies_message_when_brand_is_empty() {
        givenVerificator()
        whenChecking(vehicle: VehicleDTO(brand: "", license: "123456789", model: "model", type: Vehicle.Category.car.rawValue, year: "year"))
        thenError(is: .emptyField)
    }
    
    func test_Verfies_message_when_model_is_empty() {
        givenVerificator()
        whenChecking(vehicle: VehicleDTO(brand: "brand", license: "123456789", model: "", type: Vehicle.Category.car.rawValue, year: "year"))
        thenError(is: .emptyField)
    }
    
    func test_Verifies_message_if_year_has_an_incorrect_format() {
        givenVerificator()
        whenChecking(vehicle: VehicleDTO(brand: "brand", license: "AA-222-AA", model: "model", type: Vehicle.Category.car.rawValue, year: "222"))
        thenError(is: .incorrectYear)
    }
    
    func test_Verifies_message_when_license_has_an_incorrect_format_for_new_license() {
        givenVerificator()
        whenChecking(vehicle: VehicleDTO(brand: "brand", license: "AA-2B2-AA", model: "model", type: Vehicle.Category.car.rawValue, year: "year"))
        thenError(is: .incorrectLicenseFormat)
    }

    func test_Verifies_message_when_license_has_an_incorrect_format_for_old_license() {
        givenVerificator()
        whenChecking(vehicle: VehicleDTO(brand: "brand", license: "524 WAL 7A", model: "model", type: Vehicle.Category.car.rawValue, year: "year"))
        thenError(is: .incorrectLicenseFormat)
    }

    func test_Verifies_message_when_license_has_an_incorrect_size_for_new_license() {
        givenVerificator()
        whenChecking(vehicle: VehicleDTO(brand: "brand", license: "AA-222-AAA", model: "model", type: Vehicle.Category.car.rawValue, year: "year"))
        thenError(is: .incorrectLicenseSize)
    }

    func test_Verifies_message_when_license_has_an_incorrect_size_for_old_license() {
        givenVerificator()
        whenChecking(vehicle: VehicleDTO(brand: "brand", license: "524 WAL 7", model: "model", type: Vehicle.Category.car.rawValue, year: "year"))
        thenError(is: .incorrectLicenseSize)
    }

    func test_Verifies_message_when_license_has_a_correct_format_for_new_license() {
        givenVerificator()
        whenChecking(vehicle: VehicleDTO(brand: "brand", license: "AA-222-AA", model: "model", type: Vehicle.Category.car.rawValue, year: "year"))
        thenNoErrorThrows()
    }

    func test_Verifies_message_when_license_has_a_correct_format_for_old_license() {
        givenVerificator()
        whenChecking(vehicle: VehicleDTO(brand: "brand", license: "524 WAL 75", model: "model", type: Vehicle.Category.car.rawValue, year: "year"))
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

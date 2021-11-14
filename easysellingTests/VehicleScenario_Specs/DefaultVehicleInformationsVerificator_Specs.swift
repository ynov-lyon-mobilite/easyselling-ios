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
        whenChecking(vehicle: Vehicle(brand: "brand", model: "model", license: "", type: Vehicle.Category.car, year: "year"))
        thenError(is: vehicleCreationError)
    }
    
    func test_Verfies_message_when_brand_is_empty() {
        givenVerificator()
        whenChecking(vehicle: Vehicle(brand: "", model: "model", license: "123456789", type: Vehicle.Category.car, year: "year"))
        thenError(is: vehicleCreationError)
    }
    
    func test_Verfies_message_when_model_is_empty() {
        givenVerificator()
        whenChecking(vehicle: Vehicle(brand: "brand", model: "", license: "123456789", type: Vehicle.Category.car, year: "year"))
        thenError(is: vehicleCreationError)
    }
    
    func test_Verifies_message_if_license_has_an_icorrect_format() {
        givenVerificator()
        whenChecking(vehicle: Vehicle(brand: "brand", model: "model", license: "12345678", type: Vehicle.Category.car, year: "year"))
        thenError(is: vehicleCreationError)
    }
    
    func test_Verifies_message_if_year_has_an_icorrect_format() {
        givenVerificator()
        whenChecking(vehicle: Vehicle(brand: "brand", model: "model", license: "license", type: Vehicle.Category.car, year: "222"))
        thenError(is: vehicleCreationError)
    } 
    
    func test_Verifies_if_cheking_has_successful() {
        givenVerificator()
        whenChecking(vehicle: Vehicle(brand: "brand", model: "model", license: "123456789", type: Vehicle.Category.car, year: "year"))
        thenNoErrorThrows()
    }
    
    private func givenVerificator() {
        verificator = DefaultVehicleInformationsVerificator()
    }
    
    private func whenChecking(vehicle: Vehicle) {
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
//
//  VehicleInformationsVerificator_Specs.swift
//  easysellingTests
//
//  Created by Valentin Mont School on 07/11/2021.
//

import XCTest
@testable import easyselling

class VehicleInformationsVerificator_Specs: XCTestCase {
    
    private var verificator: VehicleInformationsVerificator!
    private var vehicleCreationError: VehicleCreationError!
    private var vehicleInformations: VehicleInformations!
    
    func test_Verfies_message_when_license_is_empty() {
        givenVerificator()
        whenChecking(vehicle: VehicleInformations(license: "", brand: "brand", type: "type", year: "2005", model: "model"))
        thenError(is: vehicleCreationError)
    }
    
    func test_Verfies_message_when_brand_is_empty() {
        givenVerificator()
        whenChecking(vehicle: VehicleInformations(license: "123456789", brand: "", type: "type", year: "2005", model: "model"))
        thenError(is: vehicleCreationError)
    }
    
    func test_Verfies_message_when_model_is_empty() {
        givenVerificator()
        whenChecking(vehicle: VehicleInformations(license: "123456789", brand: "brand", type: "type", year: "2005", model: ""))
        thenError(is: vehicleCreationError)
    }
    
    func test_Verifies_message_if_license_has_an_icorrect_format() {
        givenVerificator()
        whenChecking(vehicle: VehicleInformations(license: "12345678", brand: "brand", type: "type", year: "2005", model: "model"))
        thenError(is: vehicleCreationError)
    }
    
    func test_Verifies_message_if_year_has_an_icorrect_format() {
        givenVerificator()
        whenChecking(vehicle: VehicleInformations(license: "123456789", brand: "brand", type: "type", year: "200", model: "model"))
        thenError(is: vehicleCreationError)
    }
    
    func test_Verifies_if_cheking_has_successful() {
        givenVerificator()
        whenChecking(vehicle: VehicleInformations(license: "123456789", brand: "brand", type: "type", year: "2005", model: "model"))
        thenInformations(are: vehicleInformations)
    }
    
    private func givenVerificator() {
        verificator = VehicleInformationsVerificator()
    }
    
    private func whenChecking(vehicle: VehicleInformations) {
        do {
            self.vehicleInformations = try verificator.verifyInformations(vehicle: vehicle)
        } catch (let error) {
            self.vehicleCreationError = (error as! VehicleCreationError)
        }
    }
    
    private func thenInformations(are expected: VehicleInformations) {
        XCTAssertEqual(expected, vehicleInformations)
    }
    
    private func thenError(is expected: VehicleCreationError) {
        XCTAssertEqual(expected.description, vehicleCreationError.description)
        XCTAssertEqual(expected, vehicleCreationError)
    }
}

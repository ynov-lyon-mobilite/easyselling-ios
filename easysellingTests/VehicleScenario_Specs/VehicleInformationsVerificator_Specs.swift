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
    
    func test_Verfies_message_when_license_is_empty() {
        givenVerificator()
        let message = whenChecking(vehicle: VehicleInformations(license: "", brand: "brand", type: "type", year: "2005", model: "model"))
        thenMessage(expected: .emptyField, message: message)
    }
    
    func test_Verfies_message_when_brand_is_empty() {
        givenVerificator()
        let message = whenChecking(vehicle: VehicleInformations(license: "123456789", brand: "", type: "type", year: "2005", model: "model"))
        thenMessage(expected: .emptyField, message: message)
    }
    
    func test_Verfies_message_when_model_is_empty() {
        givenVerificator()
        let message = whenChecking(vehicle: VehicleInformations(license: "123456789", brand: "brand", type: "type", year: "2005", model: ""))
        thenMessage(expected: .emptyField, message: message)
    }
    
    func test_Verifies_if_license_has_an_icorrect_format() {
        givenVerificator()
        let message = whenChecking(vehicle: VehicleInformations(license: "12345678", brand: "brand", type: "type", year: "2005", model: "model"))
        thenMessage(expected: .incorrectLicense, message: message)
    }
    
    func test_Verifies_if_year_has_an_icorrect_format() {
        givenVerificator()
        let message = whenChecking(vehicle: VehicleInformations(license: "123456789", brand: "brand", type: "type", year: "200", model: "model"))
        thenMessage(expected: .incorrectYear, message: message)
    }
    
    private func givenVerificator() {
        verificator = VehicleInformationsVerificator()
    }
    
    private func whenChecking(vehicle: VehicleInformations) -> VehicleCreationError? {
        return verificator.verifyInformations(vehicle: vehicle) ?? nil
    }
    
    private func thenMessage(expected: VehicleCreationError, message: VehicleCreationError?) {
        XCTAssertEqual(expected, message)
    }
}

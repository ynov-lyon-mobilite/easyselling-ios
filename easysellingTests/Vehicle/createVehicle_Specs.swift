//
//  carsAddingTest.swift
//  easysellingTests
//
//  Created by Valentin Mont School on 13/10/2021.
//

import Foundation
import Combine

import XCTest
@testable import easyselling


class createVehicle_Specs: XCTestCase {
    private let vehicle = Vehicle(licenceNumber: "XOXOXOXOXOXOXO", brand: "Audi", immatriculation: "XOXOXOXO", type: .car, age: 6)
    
    private var success: Bool?
    private var message: String?
    
    func test_creates_vehicle_with_successfully_response() {
        let vehicleService = VehicleService(httpCode: 200)
        vehicleService.createNewVehicle(vehicle: vehicle) { success, _ in
            self.success = success
        }
        XCTAssertTrue(self.success ?? false)
    }
    
    func test_creates_car_with_error_response() {
        let vehicleService = VehicleService(httpCode: 400)
        vehicleService.createNewVehicle(vehicle: vehicle) { failure, _ in
            self.success = failure
        }
        XCTAssertTrue(!(self.success ?? false))
    }
    
    func test_fails_if_field_is_incorrect() {
        self.vehicle.immatriculation = "XOXO"
        let vehicleService = VehicleService(httpCode: 400)
        XCTAssertTrue(!vehicleService.checkingInformations(vehicle: vehicle))
    }
    
    func test_checks_if_the_right_message_is_showing() {
        let vehicleService = VehicleService(httpCode: 200)
        vehicleService.createNewVehicle(vehicle: vehicle) { _, message in
            self.message = message
        }
        XCTAssertEqual(HTTPMessage.responseMessages[200], message)
    }
}

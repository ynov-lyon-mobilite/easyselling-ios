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
    private var success: Bool?
    
    func test_creates_vehicle_with_successfully_response() {
        let vehicleService = VehicleService(httpCode: 200)
        vehicleService.createNewVehicle { success in
            self.success = success
        }
        XCTAssertTrue(self.success ?? false)
    }
    
    func test_creates_car_with_error_response() {
        let vehicleService = VehicleService(httpCode: 400)
        vehicleService.createNewVehicle { failure in
            self.success = failure
        }
        XCTAssertTrue(!(self.success ?? false))
    }
    
    func test_creation_car_failed_if_field_is_incorrect() {
        let vehicle = Vehicle(licenceNumber: "XOXOXOXOXOXOXO", brand: "Audi", immatriculation: "XOXOXOXO", type: .car, age: 6)
        let vehicleService = VehicleService(httpCode: 400, vehicle: vehicle)
        vehicleService.checkingInformations() { isValid in
            self.success = isValid
        }
        XCTAssertTrue(self.success ?? false)
    }
}

class VehicleService {
    private var httpCode: Int
    private var vehicle: Vehicle?
    
    init(httpCode: Int, vehicle: Vehicle? = nil) {
        self.httpCode = httpCode
        self.vehicle = vehicle
    }
    
    func createNewVehicle(callBack: @escaping (Bool) -> Void) {
        switch(httpCode) {
        case 200:
            // TODO: Back to the vehicles list in the callback
            callBack(true)
        default:
            // TODO: Display a popup in the callback
            callBack(false)
        }
    }
    
    func checkingInformations(callBack: @escaping (Bool) -> Void) {
        guard let vehicle = vehicle,
                vehicle.immatriculation.count == 8,
                vehicle.licenceNumber.count == 14,
                vehicle.age < 100 else {
            callBack(false)
            return
        }
        callBack(true)
    }
}



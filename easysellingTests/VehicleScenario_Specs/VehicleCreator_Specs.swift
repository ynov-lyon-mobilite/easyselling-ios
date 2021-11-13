//
//  VehicleCreator_Specs.swift
//  easysellingTests
//
//  Created by Valentin Mont School on 03/11/2021.
//

import XCTest
@testable import easyselling

class VehicleCreator_Specs: XCTestCase {
    
    private var vehicleCreator: VehicleCreator!
    private var vehicle: VehicleInformations!
    private var isRequestSucceed: Bool!
    private var error: APICallerError!
    
    func test_Creates_vehicle_successful() async {
        givenVehicleCreator(requestGenerator: FakeRequestGenerator(), apiCaller: SucceedingAPICaller())
        await whenCreatingVehicle(informations: vehicle)
        thenAccountIsCreated()
    }
    
    func test_Creates_vehicle_failed_with_unfound_ressources() async {
        givenVehicleCreator(requestGenerator: FakeRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        await whenCreatingVehicle(informations: vehicle)
        thenErrorCode(is: 404)
        thenErrorMessage(is: "Impossible de trouver ce que vous cherchez")
    }
    
    func test_Creates_vehicle_failed_with_wrong_url() async {
        givenVehicleCreator(requestGenerator: FakeRequestGenerator(), apiCaller: FailingAPICaller(withError: 400))
        await whenCreatingVehicle(informations: vehicle)
        thenErrorCode(is: 400)
        thenErrorMessage(is: "Une erreur est survenue")
    }
    
    func test_Creates_vehicle_failed_with_forbidden_access() async {
        givenVehicleCreator(requestGenerator: FakeRequestGenerator(), apiCaller: FailingAPICaller(withError: 403))
        await whenCreatingVehicle(informations: vehicle)
        thenErrorCode(is: 403)
        thenErrorMessage(is: "Une erreur est survenue")
    }
    
    private func givenVehicleCreator(requestGenerator: RequestGenerator, apiCaller: APICaller) {
        vehicleCreator = DefaultVehicleCreator(requestGenerator: requestGenerator, apiCaller: apiCaller)
        vehicle = VehicleInformations(brand: "Audi", model: "A1", license: "123456789", type: VehicleInformations.Category.car, year: "2005")
    }
    
    private func whenCreatingVehicle(informations: VehicleInformations) async {
        do {
            try await vehicleCreator.createVehicle(informations: informations)
            self.isRequestSucceed = true
        } catch (let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenAccountIsCreated() {
        XCTAssertTrue(isRequestSucceed)
    }
    
    private func thenErrorCode(is expected: Int) {
        XCTAssertEqual(expected, error.rawValue)
    }
    
    private func thenErrorMessage(is expected: String) {
        XCTAssertEqual(expected, error.errorDescription)
    }
}

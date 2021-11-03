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
    private var isRequestSucceed: Bool!
    private var error: APICallerError!
    
    func test_Creates_vehicle_successful() async {
        givenVehicleCreator(requestGenerator: FakeRequestGenerator("https://www.google.com"), apiCaller: SucceedingAPICaller())
        await whenCreatingVehicle()
        thenAccountIsCreated()
    }
    
    func test_Creates_vehicle_failed_with_unfound_ressources() async {
        givenVehicleCreator(requestGenerator: FakeRequestGenerator("https://www.google.com"), apiCaller: FailingAPICaller(withError: 404))
        await whenCreatingVehicle()
        thenErrorCode(is: 404)
        thenErrorMessage(is: "Impossible de trouver ce que vous cherchez")
    }
    
    func test_Creates_vehicle_failed_with_wrong_url() async {
        givenVehicleCreator(requestGenerator: FakeRequestGenerator("google.co"), apiCaller: FailingAPICaller(withError: 400))
        await whenCreatingVehicle()
        thenErrorCode(is: 400)
        thenErrorMessage(is: "Une erreur est survenue")
    }
    
    func test_Creates_vehicle_failed_with_forbidden_access() async {
        givenVehicleCreator(requestGenerator: FakeRequestGenerator("https://www.google.com"), apiCaller: FailingAPICaller(withError: 403))
        await whenCreatingVehicle()
        thenErrorCode(is: 403)
        thenErrorMessage(is: "Une erreur est survenue")
    }
    
    private func givenVehicleCreator(requestGenerator: RequestGenerator, apiCaller: APICaller) {
        vehicleCreator = VehicleCreator(requestGenerator: requestGenerator, apiCaller: apiCaller)
    }
    
    private func whenCreatingVehicle() async {
        do {
            try await vehicleCreator.createVehicle(informations: VehicleInformations(license: "123456789", brand: "Audi", type: "car", year: "2005", model: "A1"))
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

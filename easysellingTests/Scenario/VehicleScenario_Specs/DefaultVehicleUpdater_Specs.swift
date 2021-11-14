//
//  DefaultVehicleUpdater_Specs.swift
//  easysellingTests
//
//  Created by Pierre Gourgouillon on 24/11/2021.
//

import XCTest
@testable import easyselling

class DefaultVehicleUpdater_Specs: XCTestCase {

    func test_Updates_vehicle_is_successful() async {
        givenVehicleUpdater(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: SucceedingAPICaller())
        await whenUpdatingVehicle(informations: vehicle)
        thenVehicleIsUpdating()
    }

    func test_Updates_vehicle_failed_with_unfound_ressources() async {
        givenVehicleUpdater(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        await whenUpdatingVehicle(informations: vehicle)
        thenErrorCode(is: 404)
        thenErrorMessage(is: "Impossible de trouver ce que vous cherchez")
    }

    func test_Updates_vehicle_failed_with_wrong_url() async {
        givenVehicleUpdater(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 400))
        await whenUpdatingVehicle(informations: vehicle)
        thenErrorCode(is: 400)
        thenErrorMessage(is: "Une erreur est survenue")
    }

    func test_Updates_vehicle_failed_with_forbidden_access() async {
        givenVehicleUpdater(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 403))
        await whenUpdatingVehicle(informations: vehicle)
        thenErrorCode(is: 403)
        thenErrorMessage(is: "Une erreur est survenue")
    }

    private func givenVehicleUpdater(requestGenerator: AuthorizedRequestGenerator, apiCaller: APICaller) {
        vehicleUpdater =  DefaultVehicleUpdater(requestGenerator: requestGenerator, apiCaller: apiCaller)
        vehicle = VehicleDTO(brand: "Audi", model: "A1", license: "123456789", type: Vehicle.Category.car, year: "2005")
    }

    private func whenUpdatingVehicle(informations: VehicleDTO) async {
        do {
            try await vehicleUpdater.updateVehicle(id: "", informations: informations)
            self.isRequestSucceed = true
        } catch (let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenVehicleIsUpdating() {
        XCTAssertTrue(isRequestSucceed)
    }

    private func thenErrorCode(is expected: Int) {
        XCTAssertEqual(expected, error.rawValue)
    }

    private func thenErrorMessage(is expected: String) {
        XCTAssertEqual(expected, error.errorDescription)
    }

    private var vehicleUpdater: VehicleUpdater!
    private var vehicle: VehicleDTO!
    private var isRequestSucceed: Bool!
    private var error: APICallerError!
}

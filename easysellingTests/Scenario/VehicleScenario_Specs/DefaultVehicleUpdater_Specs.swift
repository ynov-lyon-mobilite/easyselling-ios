//
//  DefaultVehicleUpdater_Specs.swift
//  easysellingTests
//
//  Created by Pierre Gourgouillon on 24/11/2021.
//

import XCTest
@testable import easyselling
import CoreData

class DefaultVehicleUpdater_Specs: XCTestCase {

    private var vehicleUpdater: VehicleUpdater!
    private var vehicle: Vehicle!
    private var isRequestSucceed: Bool!
    private var error: APICallerError!
    private var context: NSManagedObjectContext!

    func test_Updates_vehicle_is_successful() async {
        givenVehicleUpdater(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: SucceedingAPICaller())
        givenCoreData()
        let vehicle = Vehicle(id: "1", brand: "Audi", model: "A1", licence: "123456789", type: .car, year: "2005")
        await whenUpdatingVehicle(informations: vehicle)
        thenVehicleIsUpdating(vehicle: vehicle)
    }

    func test_Updates_vehicle_failed_with_unfound_ressources() async {
        givenVehicleUpdater(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        await whenUpdatingVehicle(informations: Vehicle(id: "1", brand: "Audi", model: "A1", licence: "123456789", type: .car, year: "2005"))
        thenErrorCode(is: 404)
        thenErrorMessage(is: APICallerError.notFound.errorDescription)
    }

    func test_Updates_vehicle_failed_with_wrong_url() async {
        givenVehicleUpdater(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 400))
        await whenUpdatingVehicle(informations: Vehicle(id: "1", brand: "Audi", model: "A1", licence: "123456789", type: .car, year: "2005"))
        thenErrorCode(is: 400)
        thenErrorMessage(is: APICallerError.internalServerError.errorDescription)
    }

    func test_Updates_vehicle_failed_with_forbidden_access() async {
        givenVehicleUpdater(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 403))
        await whenUpdatingVehicle(informations: Vehicle(id: "1", brand: "Audi", model: "A1", licence: "123456789", type: .car, year: "2005"))
        thenErrorCode(is: 403)
        thenErrorMessage(is: APICallerError.forbidden.errorDescription)
    }

    private func givenVehicleUpdater(requestGenerator: AuthorizedRequestGenerator, apiCaller: APICaller) {
        context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        vehicleUpdater = DefaultVehicleUpdater(requestGenerator: requestGenerator, apiCaller: apiCaller, context: context)
    }

    private func givenCoreData() {
        _ = VehicleCoreData(id: "1", brand: "Audi", licence: "123456783", model: "A2", type: Vehicle.Category.car.rawValue, year: "2004", in: context)

        try? context.save()
    }

    private func whenUpdatingVehicle(informations: Vehicle) async {
        do {
            try await vehicleUpdater.updateVehicle(informations: informations)
            self.isRequestSucceed = true
        } catch (let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenVehicleIsUpdating(vehicle: Vehicle) {
        context.performAndWait {
            let vehicleCoreData = VehicleCoreData.fetchRequestById(id: "1")
            XCTAssertEqual(vehicleCoreData?.toVehicle(), vehicle)
            XCTAssertTrue(isRequestSucceed)
        }
    }

    private func thenErrorCode(is expected: Int) {
        XCTAssertEqual(expected, error.rawValue)
    }

    private func thenErrorMessage(is expected: String?) {
        XCTAssertEqual(expected, error.errorDescription)
    }
}

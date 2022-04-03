//
//  DefaultVehicleDeletor_Specs.swift
//  easysellingTests
//
//  Created by Lucas Barthélémy on 23/11/2021.
//

import XCTest
import CoreData
@testable import easyselling

class DefaultVehicleDeletor_Specs: XCTestCase {

//    func test_Deletes_vehicle_one() {
//        let vehicles = [.vehicle1, .vehicle2]
//        givenCoreData(vehicles)
//        givenDeletor()
//        whenDeletingVehicle(withId: vehicle1)
//        thenVehicles(are: [vehicle2])
//    }
//
//    func test_Does_not_delete_vehicle_from_core_data_when_delete_call_fail() {
//        let vehicles = [.vehicle1, .vehicle2]
//        givenCoreData(vehicles)
//        givenDeletor(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
//        whenDeletingVehicle(withId: vehicle1)
//        thenVehicles(are: [.vehicle1, .vehicle2])
//    }

    func test_Deletes_vehicle_succeeding() async {
        givenDeletor(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: SucceedingAPICaller())
        await whenDeletingVehicle(withId: "1")
        thenSuccess(with: "1")
    }

    func test_Deletes_failed_with_unknown_id_vehicle() async {
        givenDeletor(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        await whenDeletingVehicle(withId: "unknownId")
        thenError(is: .notFound, with: "1")
    }

    private func givenDeletor(requestGenerator: AuthorizedRequestGenerator, apiCaller: APICaller) {
        context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        deletor = DefaultVehicleDeletor(requestGenerator: requestGenerator, apiCaller: apiCaller, context: context)
        _ = VehicleCoreData(id: "1", brand: "", license: "", model: "", type: Vehicle.Category.car.rawValue, year: "", in: context)
    }

    private func whenDeletingVehicle(withId id: String) async {
        do {
            try await deletor.deleteVehicle(id: id)
            self.success = true
        } catch (let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenError(is expected: APICallerError, with id: String) {
        context.performAndWait {
            XCTAssertTrue(VehicleCoreData.fetchRequestById(id: id) != nil)
            XCTAssertEqual(expected, self.error)
        }
    }

    private func thenSuccess(with id: String) {
        context.performAndWait {
            XCTAssertTrue(VehicleCoreData.fetchRequestById(id: id) == nil)
            XCTAssertTrue(self.success)
        }
    }

    private var context: NSManagedObjectContext!
    private var deletor: DefaultVehicleDeletor!
    private var error: APICallerError!
    private var success: Bool!
}

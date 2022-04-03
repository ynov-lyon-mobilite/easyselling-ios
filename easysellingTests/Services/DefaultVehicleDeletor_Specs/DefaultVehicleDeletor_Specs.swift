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

    func test_Deletes_vehicle_one() async {
        givenDeletor(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: SucceedingAPICaller())
        givenCoreData()
        await whenDeletingVehicle(withId: "1")
        thenSuccess(withId: "1")
        thenVehicles(are: 2)
    }

    func test_Does_not_delete_vehicle_from_core_data_when_delete_call_fail() async {
        givenDeletor(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        givenCoreData()
        await whenDeletingVehicle(withId: "1")
        thenVehicles(are: 3)
    }

    func test_Deletes_vehicle_succeeding() async {
        givenDeletor(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: SucceedingAPICaller())
        await whenDeletingVehicle(withId: "1")
        thenSuccess(withId: "1")
    }

    func test_Deletes_failed_with_unknown_id_vehicle() async {
        givenDeletor(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        await whenDeletingVehicle(withId: "unknownId")
        thenError(is: .notFound)
    }

    private func givenDeletor(requestGenerator: AuthorizedRequestGenerator, apiCaller: APICaller) {
        context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        deletor = DefaultVehicleDeletor(requestGenerator: requestGenerator, apiCaller: apiCaller, context: context)
    }

    private func whenDeletingVehicle(withId id: String) async {
        do {
            try await deletor.deleteVehicle(id: id)
            self.success = true
        } catch (let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenError(is expected: APICallerError) {
        context.performAndWait {
            XCTAssertEqual(expected, self.error)
        }
    }

    private func thenSuccess(withId id: String) {
        context.performAndWait {
            XCTAssertTrue(VehicleCoreData.fetchRequestById(id: id) == nil)
            XCTAssertTrue(self.success)
        }
    }

    private func thenVehicles(are expected: Int) {
        let fetchRequest: NSFetchRequest<VehicleCoreData> = VehicleCoreData.fetchRequest()
        let vehicles = try? context.fetch(fetchRequest)
        XCTAssertEqual(expected, vehicles?.count)
    }

    private func givenCoreData() {
        _ = VehicleCoreData(id: "1", brand: "", licence: "", model: "", type: Vehicle.Category.car.rawValue, year: "", in: context)
        _ = VehicleCoreData(id: "2", brand: "", licence: "", model: "", type: Vehicle.Category.car.rawValue, year: "", in: context)
        _ = VehicleCoreData(id: "3", brand: "", licence: "", model: "", type: Vehicle.Category.car.rawValue, year: "", in: context)

        try? context.save()
    }

    private var context: NSManagedObjectContext!
    private var deletor: DefaultVehicleDeletor!
    private var error: APICallerError!
    private var success: Bool!
}

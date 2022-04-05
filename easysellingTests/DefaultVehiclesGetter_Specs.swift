//
//  DefaultVehiclesGetter_Specs.swift
//  easysellingTests
//
//  Created by Théo Tanchoux on 11/11/2021.
//

import XCTest
import CoreData
@testable import easyselling

class DefaultVehiclesGetter_Specs: XCTestCase {
    func test_Throws_error_when_request_failed() async {
        givenGetter(apiCaller: FailingAPICaller(withError: 404))
        givenCoreDataObject()
        await whenGettingVehicles()
        thenVehiclesInCoredata(expected:
                                [Vehicle(id: "", brand: "", model: "", licence: "", type: .car, year: ""),
                                Vehicle(id: "", brand: "", model: "", licence: "", type: .car, year: ""),
                                Vehicle(id: "", brand: "", model: "", licence: "", type: .car, year: "")],
                               vehicles: vehicles)
    }
    
    func test_Shows_vehicles_when_request_succeeded() async {
        givenGetter(apiCaller: DefaultAPICaller(urlSession: FakeUrlSession(localFile: .succeededVehicles)))
        await whenGettingVehicles()

        let expected = [Vehicle(id: "1", brand: "Peugeot", model: "model1", licence: "licence1", type: .car, year: "year1"),
                        Vehicle(id: "2", brand: "Renault", model: "model2", licence: "licence2", type: .car, year: "year2"),
                        Vehicle(id: "3", brand: "Citroen", model: "model3", licence: "licence3", type: .car, year: "year3")]

        let fetchRequest: NSFetchRequest<VehicleCoreData> = VehicleCoreData.fetchRequest()
        let coreDataObjects = try? context.fetch(fetchRequest)
        
        thenVehiclesInCoredata(expected: expected, vehicles: vehicles)
        thenCountVehiclesInCoreData(expected: expected.count, vehiclesInCoreData: coreDataObjects!.count)
    }

    private func givenGetter(apiCaller: APICaller) {
        context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        vehicleGetter = DefaultVehiclesGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: apiCaller, context: context)

    }

    private func givenCoreDataObject() {
        _ = VehicleCoreData(context: context)
        _ = VehicleCoreData(context: context)
        _ = VehicleCoreData(context: context)

        try? context.save()
    }

    private func whenGettingVehicles() async {
        vehicles = try? await vehicleGetter.getVehicles()
    }

    private func thenVehiclesInCoredata(expected: [Vehicle], vehicles: [Vehicle]) {
        XCTAssertEqual(expected, vehicles)
    }

    private func thenCountVehiclesInCoreData(expected: Int, vehiclesInCoreData: Int) {
        XCTAssertEqual(expected, vehiclesInCoreData)
    }

    private var vehicleGetter: DefaultVehiclesGetter!
    private var vehicles: [Vehicle]!
    private var error: APICallerError!
    private var context: NSManagedObjectContext!
}

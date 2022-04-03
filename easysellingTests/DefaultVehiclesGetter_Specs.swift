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
        givenCoreDataObject()

        let vehicleGetter = DefaultVehiclesGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404), context: context)

        let expected = [Vehicle(id: "", brand: "", model: "", licence: "", type: .car, year: ""),
                        Vehicle(id: "", brand: "", model: "", licence: "", type: .car, year: ""),
                        Vehicle(id: "", brand: "", model: "", licence: "", type: .car, year: "")]

        vehicles = try? await vehicleGetter.getVehicles()
        XCTAssertEqual(expected, vehicles)
    }
    
    func test_Shows_vehicles_when_request_succeeded() async {
        givenContext()

        let vehicleGetter = DefaultVehiclesGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: DefaultAPICaller(urlSession: FakeUrlSession(localFile: .succeededVehicles)), context: context)

        vehicles = try? await vehicleGetter.getVehicles()

        let expected = [Vehicle(id: "1", brand: "Peugeot", model: "model1", licence: "licence1", type: .car, year: "year1"),
                        Vehicle(id: "2", brand: "Renault", model: "model2", licence: "licence2", type: .car, year: "year2"),
                        Vehicle(id: "3", brand: "Citroen", model: "model3", licence: "licence3", type: .car, year: "year3")]

        let fetchRequest: NSFetchRequest<VehicleCoreData> = VehicleCoreData.fetchRequest()
        let coreDataObjects = try? context.fetch(fetchRequest)
        
        XCTAssertEqual(expected, vehicles)
        XCTAssertEqual(expected.count, coreDataObjects?.count)
    }

    func givenContext() {
        context = TestCoreDataStack().persistentContainer.newBackgroundContext()
    }

    func givenCoreDataObject() {
        givenContext()

        _ = VehicleCoreData(context: context)
        _ = VehicleCoreData(context: context)
        _ = VehicleCoreData(context: context)

        try? context.save()
    }
    
    private var vehicles: [Vehicle]!
    private var error: APICallerError!
    private var context: NSManagedObjectContext!
}

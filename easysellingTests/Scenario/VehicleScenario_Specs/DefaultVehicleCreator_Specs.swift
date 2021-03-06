//
//  VehicleCreator_Specs.swift
//  easysellingTests
//
//  Created by Valentin Mont School on 03/11/2021.
//

import XCTest
@testable import easyselling
import CoreData

class DefaultVehicleCreator_Specs: XCTestCase {
    
    private var vehicleCreator: VehicleCreator!
    private var isRequestSucceed: Bool!
    private var error: APICallerError!
    private var context: NSManagedObjectContext!
    
    func test_Creates_vehicle_successful() async {
        givenVehicleCreator(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: SucceedingAPICaller() {
            return Vehicle(id: "", brand: "", model: "", licence: "", type: .car, year: "")
        })
        await whenCreatingVehicle(informations: VehicleDTO(brand: "Audi", licence: "123456789", model: "A1", type: .car, year: "2005"))
        thenVehicleIsCreated()
    }
    
    func test_Creates_vehicle_failed_with_unfound_ressources() async {
        givenVehicleCreator(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        await whenCreatingVehicle(informations: VehicleDTO(brand: "Audi", licence: "123456789", model: "A1", type: .car, year: "2005"))
        thenErrorCode(is: 404)
        thenErrorMessage(is: APICallerError.notFound.errorDescription)
    }
    
    func test_Creates_vehicle_failed_with_wrong_url() async {
        givenVehicleCreator(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 400))
        await whenCreatingVehicle(informations: VehicleDTO(brand: "Audi", licence: "123456789", model: "A1", type: .car, year: "2005"))
        thenErrorCode(is: 400)
        thenErrorMessage(is: APICallerError.internalServerError.errorDescription)
    }
    
    func test_Creates_vehicle_failed_with_forbidden_access() async {
        givenVehicleCreator(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 403))
        await whenCreatingVehicle(informations: VehicleDTO(brand: "Audi", licence: "123456789", model: "A1", type: .car, year: "2005"))
        thenErrorCode(is: 403)
        thenErrorMessage(is: APICallerError.forbidden.errorDescription)
    }
    
    private func givenVehicleCreator(requestGenerator: AuthorizedRequestGenerator, apiCaller: APICaller) {
        context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        vehicleCreator = DefaultVehicleCreator(requestGenerator: requestGenerator, apiCaller: apiCaller, context: context)
    }
    
    private func whenCreatingVehicle(informations: VehicleDTO) async {
        do {
            try await vehicleCreator.createVehicle(informations: informations)
            self.isRequestSucceed = true
        } catch (let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenVehicleIsCreated() {
        let fetchRequest: NSFetchRequest<VehicleCoreData> = VehicleCoreData.fetchRequest()
        let coreDataObjects = try? context.fetch(fetchRequest)

        XCTAssertEqual(1, coreDataObjects?.count)
        XCTAssertTrue(isRequestSucceed)
    }
    
    private func thenErrorCode(is expected: Int) {
        XCTAssertEqual(expected, error.rawValue)
    }
    
    private func thenErrorMessage(is expected: String?) {
        XCTAssertEqual(expected, error.errorDescription)
    }
}

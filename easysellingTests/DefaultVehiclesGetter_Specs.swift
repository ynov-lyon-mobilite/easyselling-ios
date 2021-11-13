//
//  DefaultVehiclesGetter_Specs.swift
//  easysellingTests
//
//  Created by Théo Tanchoux on 11/11/2021.
//

import XCTest
@testable import easyselling

class DefaultVehiclesGetter_Specs: XCTestCase {
    func test_Throws_error_when_request_failed() async {
        let vehicleGetter = DefaultVehiclesGetter(requestGenerator: FakeRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        do {
            _ = try  await vehicleGetter.getVehicles()
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
        XCTAssertEqual(.notFound, self.error)
    }
    
    func test_Shows_vehicles_when_request_succeeded() async {
        let vehicleGetter = DefaultVehiclesGetter(requestGenerator: FakeRequestGenerator(), apiCaller: DefaultAPICaller(urlSession: FakeUrlSession(localFile: .succeededVehicles)))
        do {
            vehicles = try await vehicleGetter.getVehicles()
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
        
        let expected = [VehicleInformations(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year:          "year1"),
                        VehicleInformations(id: "2", brand: "Renault", model: "model2", license: "license2", type: .car, year: "year2"),
                        VehicleInformations(id: "3", brand: "Citroen", model: "model3", license: "license3", type: .car, year: "year3")]
        
        XCTAssertEqual(expected, vehicles)

    }
    
    private var vehicles: [VehicleInformations]!
    private var error: APICallerError!
}

class SucceedingVehiclesGetter: VehiclesGetter {
    
    init(_ vehicles: [VehicleInformations]) {
        self.vehicles = vehicles
    }
    
    private var vehicles: [VehicleInformations]
    
    func getVehicles() async throws -> [VehicleInformations] {
        return vehicles
    }
}

class FailingVehiclesGetter: VehiclesGetter {
    
    init(withError error: APICallerError) {
        self.error = error
    }
    
    private var error: APICallerError
    
    func getVehicles() async throws -> [VehicleInformations] {
        throw error
    }
}

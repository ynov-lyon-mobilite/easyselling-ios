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
        let vehicleGetter = DefaultVehiclesGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        do {
            _ = try  await vehicleGetter.getVehicles()
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
        XCTAssertEqual(.notFound, self.error)
    }
    
    func test_Shows_vehicles_when_request_succeeded() async {
        let vehicleGetter = DefaultVehiclesGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: DefaultAPICaller(urlSession: FakeUrlSession(localFile: .succeededVehicles)))
        do {
            vehicles = try await vehicleGetter.getVehicles()
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
        
        let expected = [Vehicle(id: "1", brand: "Peugeot", model: "model1", licence: "licence1", type: .car, year: "year1"),
                        Vehicle(id: "2", brand: "Renault", model: "model2", licence: "licence2", type: .car, year: "year2"),
                        Vehicle(id: "3", brand: "Citroen", model: "model3", licence: "licence3", type: .car, year: "year3")]
        
        XCTAssertEqual(expected, vehicles)

    }
    
    private var vehicles: [Vehicle]!
    private var error: APICallerError!
}

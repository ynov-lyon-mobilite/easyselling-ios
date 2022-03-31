//
//  DefaultVehicleGetter_Specs.swift
//  easysellingTests
//
//  Created by Théo Tanchoux on 09/03/2022.
//

import XCTest
@testable import easyselling

class DefaultVehicleGetter_Specs: XCTestCase {
    func test_Throws_error_when_request_failed() async {
        let vehicleGetter = DefaultVehicleGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        do {
            _ = try  await vehicleGetter.getVehicle(id: "1")
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
        XCTAssertEqual(.notFound, self.error)
    }

    func test_Shows_vehicle_when_request_succeeded() async {
        let vehicleGetter = DefaultVehicleGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: DefaultAPICaller(urlSession: FakeUrlSession(localFile: .succeededVehicle)))
        do {
            vehicle = try await vehicleGetter.getVehicle(id: "1")
        } catch(let error) {
            self.error = (error as! APICallerError)
        }

        let expected = Vehicle(id: "1", brand: "Peugeot", model: "model1", license: "license1", type: .car, year: "year1")

        XCTAssertEqual(expected, vehicle)

    }

    private var vehicle: Vehicle!
    private var error: APICallerError!
}

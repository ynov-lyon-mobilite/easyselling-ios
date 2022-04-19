//
//  DefaultVehicleGetter_Specs.swift
//  easysellingTests
//
//  Created by Théo Tanchoux on 09/03/2022.
//

import XCTest
@testable import easyselling

class DefaultSharedVehicleGetter_Specs: XCTestCase {
    func test_Throws_error_when_request_failed() async {
        let sharedVehiclesGetter = DefaultSharedVehiclesGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        do {
            _ = try  await sharedVehiclesGetter.getSharedVehicles()
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
        XCTAssertEqual(.notFound, self.error)
    }

    func test_Shows_vehicle_when_request_succeeded() async {
        let expected = [Vehicle(id: "1", brand: "Peugeot", model: "model1", licence: "license1", type: .car, year: "year1")]

        let vehicleGetter = DefaultSharedVehiclesGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: DefaultAPICaller(urlSession: FakeUrlSession(localFile: .succeededVehicle)))
        do {
            vehicles = try await vehicleGetter.getSharedVehicles()
        } catch(let error) {
            self.error = (error as! APICallerError)
        }

        XCTAssertEqual(expected, vehicles)
    }

    private var vehicles: [Vehicle]!
    private var error: APICallerError!
}

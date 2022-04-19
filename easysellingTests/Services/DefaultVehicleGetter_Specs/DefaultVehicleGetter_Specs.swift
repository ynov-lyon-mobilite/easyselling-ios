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
        givenShareVehiclesGetter(apiCaller: FailingAPICaller(withError: 404))
        await whenGettingSharedVehicles()
        thenError(is: .notFound)
    }

    func test_Shows_vehicle_when_request_succeeded() async {
        givenShareVehiclesGetter()
        await whenGettingSharedVehicles()
        thenVehicles(are: [Vehicle(id: "1", brand: "Peugeot", model: "model1", licence: "licence1", type: .car, year: "year1")])
    }

    private func givenShareVehiclesGetter(apiCaller: APICaller = DefaultAPICaller(urlSession: FakeUrlSession(localFile: .succeededVehicle))) {
        vehicleGetter = DefaultSharedVehiclesGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: apiCaller)
    }

    private func whenGettingSharedVehicles() async {
        do {
            vehicles = try await vehicleGetter.getSharedVehicles()
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenVehicles(are expected: [Vehicle]) {
        XCTAssertEqual(expected, vehicles)
    }

    private func thenError(is expected: APICallerError) {
        XCTAssertEqual(expected, self.error)
    }

    private var vehicleGetter: DefaultSharedVehiclesGetter!
    private var vehicles: [Vehicle]!
    private var error: APICallerError!
}

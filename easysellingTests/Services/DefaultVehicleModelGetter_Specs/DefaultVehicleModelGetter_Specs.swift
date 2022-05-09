//
//  DefaultVehicleModelGetter_Specs.swift
//  easysellingTests
//
//  Created by Lucas Barthélémy on 07/05/2022.
//

import XCTest
@testable import easyselling

class DefaultVehicleModelGetter_Specs: XCTestCase {

    func test_Shows_vehicle_model_when_request_succeeded() async {
        let expectedModel = [
            Model(id: "1", brand: "4", model: "2008", type: .car),
            Model(id: "56", brand: "65", model: "911", type: .car),
            Model(id: "89", brand: "78", model: "MT-07", type: .moto)
        ]

        givenGetter(withAPICaller: DefaultAPICaller(urlSession: FakeUrlSession(localFile: .succeededVehicleModel)))
        await whenTryingToGetVehicleModel()
        thenReturnedModel(are: expectedModel)
    }

    func test_Throws_error_when_request_failed() async {
        givenGetter(withAPICaller: FailingAPICaller(withError: 400))
        await whenTryingToGetVehicleModel()
        thenErrorCode(is: 400)
    }

    private func givenGetter(withAPICaller apiCaller: APICaller) {
        vehicleModelGetter = DefaultVehicleModelGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: apiCaller)
    }

    private func whenTryingToGetVehicleModel() async {
        do {
            model = try await vehicleModelGetter.getVehicleModel()
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenReturnedModel(are expected: [Model]) {
        XCTAssertEqual(expected, model)
    }

    private func thenErrorCode(is expected: Int) {
        XCTAssertEqual(expected, error.rawValue)
    }

    private var model: [Model]!
    private var vehicleModelGetter: DefaultVehicleModelGetter!
    private var error: APICallerError!
}

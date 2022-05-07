//
//  DefaultVehicleBrandGetter_Specs.swift
//  easysellingTests
//
//  Created by Lucas Barthélémy on 07/05/2022.
//

import XCTest
@testable import easyselling

class DefaultVehicleBrandGetter_Specs: XCTestCase {

    func test_Shows_vehicle_brand_when_request_succeeded() async {
        let expectedBrand = [
            Brand(id: "1", name: "Peugeot"),
            Brand(id: "56", name: "Porsche"),
            Brand(id: "89", name: "Yamaha")
        ]

        givenGetter(withAPICaller: DefaultAPICaller(urlSession: FakeUrlSession(localFile: .succeededVehicleBrand)))
        await whenTryingToGetVehicleBrand()
        thenReturnedBrand(are: expectedBrand)
    }

    func test_Throws_error_when_request_failed() async {
        givenGetter(withAPICaller: FailingAPICaller(withError: 400))
        await whenTryingToGetVehicleBrand()
        thenErrorCode(is: 400)
    }

    private func givenGetter(withAPICaller apiCaller: APICaller) {
        vehicleBrandGetter = DefaultVehicleBrandGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: apiCaller)
    }

    private func whenTryingToGetVehicleBrand() async {
        do {
            brand = try await vehicleBrandGetter.getVehicleBrand()
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenReturnedBrand(are expected: [Brand]) {
        XCTAssertEqual(expected, brand)
    }

    private func thenErrorCode(is expected: Int) {
        XCTAssertEqual(expected, error.rawValue)
    }

    private var brand: [Brand]!
    private var vehicleBrandGetter: DefaultVehicleBrandGetter!
    private var error: APICallerError!
}

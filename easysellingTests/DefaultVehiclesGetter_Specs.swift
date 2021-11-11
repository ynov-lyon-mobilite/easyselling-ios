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
    
    private var error: APICallerError!
}

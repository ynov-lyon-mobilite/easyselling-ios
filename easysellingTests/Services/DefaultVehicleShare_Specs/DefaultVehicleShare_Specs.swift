//
//  DefaultVehicleShare_Specs.swift
//  easyselling
//
//  Created by Théo Tanchoux on 09/03/2022.
//

import XCTest
@testable import easyselling

class DefaultVehicleShare_Specs: XCTestCase {
    func test_Throws_error_when_request_failed() async {
        let vehicleShare = DefaultVehicleShare(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 400))
        do {
            _ = try await vehicleShare.shareVehicle(id: "1", email: "test@email.com")
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
        XCTAssertEqual(.badRequest, self.error)
    }

    private var error: APICallerError!
}

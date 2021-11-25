//
//  DefaultVehicleDeletor_Specs.swift
//  easysellingTests
//
//  Created by Lucas Barthélémy on 23/11/2021.
//

import XCTest
@testable import easyselling

class DefaultVehicleDeletor_Specs: XCTestCase {
    func test_Deletes_succeeding() async {
        givenDeletor(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: SucceedingAPICaller())
        await whenDeletingVehicle(withId: "1")
        thenSuccess()
    }

    func test_Deletes_failed_with_unknown_id_vehicle() async {
        givenDeletor(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        await whenDeletingVehicle(withId: "unknown id")
        thenError(is: .notFound)
    }

    private func givenDeletor(requestGenerator: AuthorizedRequestGenerator, apiCaller: APICaller) {
       deletor = DefaultVehicleDeletor(requestGenerator: requestGenerator, apiCaller: apiCaller)
    }

    private func whenDeletingVehicle(withId id: String) async {
        do {
            try await deletor.deleteVehicle(id: id)
            self.success = true
        } catch (let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenError(is expected: APICallerError) {
        XCTAssertEqual(expected, self.error)
    }

    private func thenSuccess() {
        XCTAssertTrue(self.success)
    }

    private var deletor: DefaultVehicleDeletor!
    private var error: APICallerError!
    private var success: Bool!
}

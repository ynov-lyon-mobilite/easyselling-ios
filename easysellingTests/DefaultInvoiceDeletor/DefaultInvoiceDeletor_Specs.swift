//
//  DefaultInvoiceDeletor_Specs.swift
//  easysellingTests
//
//  Created by Pierre Gourgouillon on 15/12/2021.
//

import XCTest
@testable import easyselling

class DefaultInvoiceDeletor_Specs: XCTestCase {

    func test_Deletes_succeeding() async {
        givenDeletor(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: SucceedingAPICaller())
        await whenDeletingInvoice(withId: 1)
        thenSuccess()
    }

    func test_Deletes_failed_with_unknown_id_invoice() async {
        givenDeletor(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        await whenDeletingInvoice(withId: 0897870)
        thenError(is: .notFound)
    }

    private func givenDeletor(requestGenerator: AuthorizedRequestGenerator, apiCaller: APICaller) {
       deletor = DefaultInvoiceDeletor(requestGenerator: requestGenerator, apiCaller: apiCaller)
    }

    private func whenDeletingInvoice(withId id: Int) async {
        do {
            try await deletor.deleteInvoice(id: id)
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

    private var deletor: DefaultInvoiceDeletor!
    private var error: APICallerError!
    private var success: Bool!
}

//
//  DefaultInvoiceDeletor_Specs.swift
//  easysellingTests
//
//  Created by Pierre Gourgouillon on 15/12/2021.
//

import XCTest
@testable import easyselling
import CoreData

class DefaultInvoiceDeletor_Specs: XCTestCase {

    func test_Deletes_succeeding() async {
        givenDeletor(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: SucceedingAPICaller())
        await whenDeletingInvoice(withId: "A1231")
        thenSuccess(with: "A1231")
    }

    func test_Deletes_failed_with_unknown_id_invoice() async {
        givenDeletor(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        await whenDeletingInvoice(withId: "A1231")
        thenError(is: .notFound, with: "A1231")
    }

    private func givenDeletor(requestGenerator: AuthorizedRequestGenerator, apiCaller: APICaller) {
        context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        deletor = DefaultInvoiceDeletor(requestGenerator: requestGenerator, apiCaller: apiCaller, context: context)
        _ = InvoiceCoreData(id: "A1231", fileTitle: "", fileData: Data(), in: context)
    }

    private func whenDeletingInvoice(withId id: String) async {
        do {
            try await deletor.deleteInvoice(id: id)
            self.success = true
        } catch (let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenError(is expected: APICallerError, with id: String) {
        context.performAndWait {
            XCTAssertTrue(InvoiceCoreData.fetchRequestById(id: id) != nil)
            XCTAssertEqual(expected, self.error)
        }
    }

    private func thenSuccess(with id: String) {
        context.performAndWait {
            XCTAssertTrue(InvoiceCoreData.fetchRequestById(id: id) == nil)
            XCTAssertTrue(self.success)
        }
    }

    private var context: NSManagedObjectContext!
    private var deletor: DefaultInvoiceDeletor!
    private var error: APICallerError!
    private var success: Bool!
}

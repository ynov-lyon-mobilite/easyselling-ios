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
        let expected: [InvoiceCoreData] = []
        givenCoreDataContext()
        givenDeletor(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: SucceedingAPICaller(), accordingInvoices: [InvoiceCoreData(id: "A1231", fileTitle: "", fileData: Data(), fileLabel: "label", fileMileage: 0, fileDate: Date(), fileVehicle: "vehicle", in: context)])
        await whenDeletingInvoice(withId: "A1231")
        thenInvoices(withId: "A1231", expected: expected)
    }

    func test_Deletes_failed_with_unknown_id_invoice() async {
        givenCoreDataContext()
        givenDeletor(requestGenerator: FakeAuthorizedRequestGenerator(),
                     apiCaller: FailingAPICaller(withError: 404),
                     accordingInvoices: [InvoiceCoreData(id: "A1231", fileTitle: "", fileData: Data(), fileLabel: "label", fileMileage: 0, fileDate: Date(), fileVehicle: "vehicle", in: context)])
        await whenDeletingInvoice(withId: "unknowId")
        thenError(is: .notFound)
    }

    private func givenCoreDataContext() {
        context = TestCoreDataStack().persistentContainer.newBackgroundContext()
    }

    private func givenDeletor(requestGenerator: AuthorizedRequestGenerator, apiCaller: APICaller, accordingInvoices: [InvoiceCoreData]) {
        deletor = DefaultInvoiceDeletor(requestGenerator: requestGenerator, apiCaller: apiCaller, context: context)
    }

    private func whenDeletingInvoice(withId id: String) async {
        do {
            try await deletor.deleteInvoice(id: id)
            self.success = true
        } catch (let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenError(is expected: APICallerError) {
        context.performAndWait {
            XCTAssertEqual(expected, self.error)
        }
    }

    private func thenInvoices(withId id: String, expected: [InvoiceCoreData]) {
        context.performAndWait {
            let fetchRequest: NSFetchRequest<InvoiceCoreData> = InvoiceCoreData.fetchRequest()
            let invoices = try? context.fetch(fetchRequest)
            XCTAssertTrue(InvoiceCoreData.fetchRequestById(id: id) == nil)
            XCTAssertTrue(self.success)
            XCTAssertEqual(invoices?.count, expected.count)
        }
    }

    private var context: NSManagedObjectContext!
    private var deletor: DefaultInvoiceDeletor!
    private var error: APICallerError!
    private var success: Bool!
}

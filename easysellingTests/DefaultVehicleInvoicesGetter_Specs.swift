//
//  DefaultVehicleInvoicesGetter_Specs.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 24/11/2021.
//

import XCTest
import CoreData
@testable import easyselling

class DefaultVehicleInvoicesGetter_Specs: XCTestCase {

    private var invoices: [Invoice]!
    private var invoiceGetter: DefaultVehicleInvoicesGetter!
    private var invoiceCoreData: InvoiceCoreData!
    private var error: APICallerError!
    private var context: NSManagedObjectContext!

    func test_Shows_vehicle_invoices_when_request_succeeded() async {
        let expectedInvoices = [
            Invoice(id: "0AJEAZ9", file: nil),
            Invoice(id: "0AJEAZ8", file: nil),
            Invoice(id: "0AJEAZ7", file: nil)
        ]
        
        givenCoreDataObject()
        givenGetter(withAPICaller: DefaultAPICaller(urlSession: FakeUrlSession(localFile: .succeededInvoices)))
        await whenTryingToGetVehicleInvoices()
        thenReturnedInvoices(are: expectedInvoices)
    }
    
    func test_Throws_error_when_request_failed() async {
        let expected = [
            Invoice(id: "test", fileData: Data()),
            Invoice(id: "test1", fileData: Data()),
            Invoice(id: "test2", fileData: Data())
        ]

        givenCoreDataObject()
        givenGetter(withAPICaller: FailingAPICaller(withError: 400))
        await whenTryingToGetVehicleInvoices()
        thenReturnedInvoices(are: expected)
    }

    private func givenContext() {
        context = TestCoreDataStack().persistentContainer.newBackgroundContext()
    }

    func givenCoreDataObject() {
        givenContext()
        _ = InvoiceCoreData(id: "test", fileTitle: "test", fileData: Data(), in: context)
        _ = InvoiceCoreData(id: "test1", fileTitle: "test1", fileData: Data(), in: context)
        _ = InvoiceCoreData(id: "test2", fileTitle: "test2", fileData: Data(), in: context)

        try? context.save()
    }

    private func givenGetter(withAPICaller apiCaller: APICaller) {
        invoiceGetter = DefaultVehicleInvoicesGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: apiCaller, context: context)
    }

    private func whenTryingToGetVehicleInvoices() async {
        do {
            invoices = try await invoiceGetter.getInvoices(ofVehicleId: "VehicleId")
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenReturnedInvoices(are expected: [Invoice]) {
        XCTAssertEqual(expected, invoices)
    }
}

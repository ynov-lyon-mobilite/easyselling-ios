//
//  DefaultVehicleInvoicesGetter_Specs.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 24/11/2021.
//

import XCTest
@testable import easyselling

class DefaultVehicleInvoicesGetter_Specs: XCTestCase {

    private var invoices: [InvoiceCoreData]!
    private var invoiceGetter: DefaultVehicleInvoicesGetter!
    private var error: APICallerError!
    
    func test_Shows_vehicle_invoices_when_request_succeeded() async {
        let expectedInvoices = [Invoice(),
                                Invoice(),
                                Invoice()]

        givenGetter(withAPICaller: DefaultAPICaller(urlSession: FakeUrlSession(localFile: .succeededInvoices)))
        await whenTryingToGetVehicleInvoices()
        thenReturnedInvoices(are: expectedInvoices)
    }
    
    func test_Throws_error_when_request_failed() async {
        givenGetter(withAPICaller: FailingAPICaller(withError: 400))
        await whenTryingToGetVehicleInvoices()
        thenErrorCode(is: 400)
    }

    private func givenGetter(withAPICaller apiCaller: APICaller) {
        invoiceGetter = DefaultVehicleInvoicesGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: apiCaller)
    }

    private func whenTryingToGetVehicleInvoices() async {
        do {
            invoices = try await invoiceGetter.getInvoices(ofVehicleId: "VehicleId")
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenReturnedInvoices(are expected: [InvoiceCoreData]) {
        XCTAssertEqual(expected, invoices)
    }

    private func thenErrorCode(is expected: Int) {
        XCTAssertEqual(expected, error.rawValue)
    }
}

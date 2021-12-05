//
//  DefaultVehicleInvoicesGetter_Specs.swift
//  easysellingTests
//
//  Created by Corentin Laurencine on 24/11/2021.
//

import XCTest
@testable import easyselling

class DefaultVehicleInvoicesGetter_Specs: XCTestCase {

    private var invoices: [Invoice]!
    private var invoiceGetter: DefaultVehicleInvoicesGetter!
    private var error: APICallerError!

    func test_Shows_vehicle_invoices_when_request_succeeded() async {
        let expected = [Invoice(id: 1, vehicle: "1", file: "1", dateCreated: "date1", dateUpdated: ""),
                        Invoice(id: 2, vehicle: "1", file: "2", dateCreated: "date2", dateUpdated: ""),
                        Invoice(id: 3, vehicle: "2", file: "3", dateCreated: "date3", dateUpdated: "")]

        givenGetter(withAPICaller: DefaultAPICaller(urlSession: FakeUrlSession(localFile: .succeededInvoices)))
        await whenTryingToGetVehicleInvoices()
        thenReturnInvoices(expected)
    }

    func test_Throws_error_when_request_failed() async {
        givenGetter(withAPICaller: FailingAPICaller(withError: 404))
        await whenTryingToGetVehicleInvoices()
        thenError()
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

    private func thenReturnInvoices(_ expected: [Invoice]) {
        XCTAssertEqual(expected, invoices)
    }

    private func thenError() {
        XCTAssertEqual(.notFound, self.error)
    }
}

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
    private var error: APICallerError!

    func test_Shows_vehicle_invoices_when_request_succeeded() async {
        let invoiceGetter = DefaultVehicleInvoicesGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: DefaultAPICaller(urlSession: FakeUrlSession(localFile: .succeededInvoices)))
        do {
            invoices = try await invoiceGetter.getInvoices(ofVehicleId: "VehicleId")
        } catch(let error) {
            self.error = (error as! APICallerError)
        }

        let expected = [Invoice(id: 1, vehicle: "1", file: "1", date_created: "date1", date_updated: ""),
                        Invoice(id: 2, vehicle: "1", file: "2", date_created: "date2", date_updated: ""),
                        Invoice(id: 3, vehicle: "2", file: "3", date_created: "date3", date_updated: "")]
        
        XCTAssertEqual(expected, invoices)
    }

    func test_Shows_error_when_request_failed() async {
        let invoiceGetter = DefaultVehicleInvoicesGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        do {
            _ = try await invoiceGetter.getInvoices(ofVehicleId: "VehicleId")
        } catch (let error) {
            self.error = (error as! APICallerError)
        }
        XCTAssertEqual(.notFound, self.error)
    }

}

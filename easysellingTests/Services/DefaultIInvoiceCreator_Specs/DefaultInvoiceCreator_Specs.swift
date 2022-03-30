//
//  DefaultInvoiceCreator_Specs.swift
//  easysellingTests
//
//  Created by Maxence on 14/11/2021.
//

import XCTest
@testable import easyselling

class DefaultInvoiceCreator_Specs: XCTestCase {
    func test_Creates_vehicle_successful() async {
        givenVehicleCreator(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: SucceedingAPICaller())
        await whenCreatingInvoice(vehicleId: UUID().uuidString, informations: invoiceInformations)
        thenInvoiceIsCreated()
    }

    func test_Creates_vehicle_failed_with_unfound_ressources() async {
        givenVehicleCreator(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        await whenCreatingInvoice(vehicleId: UUID().uuidString, informations: invoiceInformations)
        thenErrorCode(is: 404)
        thenErrorMessage(is: "Impossible de trouver ce que vous cherchez")
    }

    func test_Creates_vehicle_failed_with_wrong_url() async {
        givenVehicleCreator(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 400))
        await whenCreatingInvoice(vehicleId: UUID().uuidString, informations: invoiceInformations)
        thenErrorCode(is: 400)
        thenErrorMessage(is: "Une erreur est survenue")
    }

    func test_Creates_vehicle_failed_with_forbidden_access() async {
        givenVehicleCreator(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 403))
        await whenCreatingInvoice(vehicleId: UUID().uuidString, informations: invoiceInformations)
        thenErrorCode(is: 403)
        thenErrorMessage(is: "Une erreur est survenue")
    }

    private func givenVehicleCreator(requestGenerator: AuthorizedRequestGenerator, apiCaller: APICaller) {
        invoiceCreator = DefaultInvoiceCreator(requestGenerator: requestGenerator, apiCaller: apiCaller)
        invoiceInformations = InvoiceDTO(file: UUID().uuidString)
    }

    private func whenCreatingInvoice(vehicleId: String, informations: InvoiceDTO) async {
        do {
            try await invoiceCreator.createInvoice(vehicleId: vehicleId, invoice: informations)
            self.isRequestSucceed = true
        } catch (let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenInvoiceIsCreated() {
        XCTAssertTrue(isRequestSucceed)
    }

    private func thenErrorCode(is expected: Int) {
        XCTAssertEqual(expected, error.rawValue)
    }

    private func thenErrorMessage(is expected: String) {
        XCTAssertEqual(expected, error.errorDescription)
    }

    private var invoiceCreator: InvoiceCreator!
    private var invoiceInformations: InvoiceDTO!
    private var isRequestSucceed: Bool!
    private var error: APICallerError!
}

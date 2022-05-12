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
            Invoice(id: "test", file: FileResponse(filename: "myFile.pdf"), label: "label1",
                    mileage: 10000, date: Date().zeroSeconds, vehicle: "vehicle1"),
            Invoice(id: "test1", file: FileResponse(filename: "myFile.pdf"), label: "label2", mileage: 10000, date: Date().zeroSeconds, vehicle: "vehicle2"),
            Invoice(id: "test2", file: FileResponse(filename: "myFile.pdf"), label: "label3", mileage: 10000, date: Date().zeroSeconds, vehicle: "vehicle3")
        ]
        
        givenCoreDataObject()
        givenGetter(withAPICaller: DefaultAPICaller(urlSession: FakeUrlSession(localFile: .succeededInvoices)))
        await whenTryingToGetVehicleInvoices()
        thenReturnedInvoices(are: expectedInvoices)
    }
    
    func test_Shows_invoices_from_coredata_when_api_request_failed() async {
        let expected = [
            Invoice(id: "test", file: FileResponse(filename: "myFile.pdf"), label: "label1", mileage: 10000, date: Date().zeroSeconds, vehicle: "vehicle1"),
            Invoice(id: "test1", file: FileResponse(filename: "myFile.pdf"), label: "label2", mileage: 10000, date: Date().zeroSeconds, vehicle: "vehicle2"),
            Invoice(id: "test2", file: FileResponse(filename: "myFile.pdf"), label: "label3", mileage: 10000, date: Date().zeroSeconds, vehicle: "vehicle3")
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
        _ = InvoiceCoreData(id: "test", fileTitle: "myFile.pdf", fileData: Data(), fileLabel: "label1", fileMileage: 10000, fileDate: Date().zeroSeconds, fileVehicle: "vehicle1", in: context)
        _ = InvoiceCoreData(id: "test1", fileTitle: "myFile.pdf", fileData: Data(), fileLabel: "label2", fileMileage: 10000, fileDate: Date().zeroSeconds, fileVehicle: "vehicle2", in: context)
        _ = InvoiceCoreData(id: "test2", fileTitle: "myFile.pdf", fileData: Data(), fileLabel: "label3", fileMileage: 10000, fileDate: Date().zeroSeconds, fileVehicle: "vehicle3", in: context)

        try? context.save()
    }

    private func givenGetter(withAPICaller apiCaller: APICaller) {
        invoiceGetter = DefaultVehicleInvoicesGetter(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: apiCaller, context: context)
    }

    private func whenTryingToGetVehicleInvoices() async {
        do {
            invoices = try await invoiceGetter.getInvoices(ofVehicleId: "test")
            invoices.sort { $0.id < $1.id }
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func thenReturnedInvoices(are expected: [Invoice]) {
        XCTAssertEqual(expected, invoices)
    }
}

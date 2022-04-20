//
//  DefaultInvoiceDownloader_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 05/12/2021.
//

import XCTest
import CoreData
@testable import easyselling

class DefaultInvoiceDownloader_Specs: XCTestCase {

    func test_Downloads_file_successfully() async {
        givenCoreDataObject()
        givenInvoiceDownloader(requestGenerator: FakeAuthorizedRequestGenerator(),
                               imageCaller: DefaultImageCaller(urlSession: FakeUrlSession(localFile: .succeededFile)))
        await whenTryingToDownloadFile(id: "")
        thenFileImageIsNotEmpty()
    }

    func test_Throws_error_when_download_failed() async {
        let expected = UIImage()

        givenCoreDataObject()
        givenInvoiceDownloader(requestGenerator: FakeAuthorizedRequestGenerator(),
                               imageCaller: FailingImageCaller(withError: 404))
        await whenTryingToDownloadFile(id: "title")
        thenFileDataIsNotEmpty(are: expected)
    }

    private func givenContext() {
        context = TestCoreDataStack().persistentContainer.newBackgroundContext()
    }

    func givenCoreDataObject() {
        givenContext()
        _ = InvoiceCoreData(id: "test", fileTitle: "title", fileData: Data(count: 3), in: context)

        try? context.save()
    }

    private func givenInvoiceDownloader(requestGenerator: AuthorizedRequestGenerator, imageCaller: ImageCaller) {
        downloader = DefaultInvoiceDownloader(requestGenerator: requestGenerator, imageCaller: imageCaller, context: context)
    }

    private func whenTryingToDownloadFile(id: String) async {
        do {
            downloadedFile = try await downloader.downloadInvoiceFile(id: id)
        } catch(let error) {
            self.error = error as? APICallerError
        }
    }

    private func thenFileDataIsNotEmpty(are expected: UIImage) {
        XCTAssertEqual(expected, downloadedFile)
    }

    private func thenFileImageIsNotEmpty() {
        XCTAssertNotNil(downloadedFile, "Image should not be nil")
    }

    private var downloader: DefaultInvoiceDownloader!
    private var downloadedFile: UIImage!
    private var error: APICallerError!
    private var context: NSManagedObjectContext!
}

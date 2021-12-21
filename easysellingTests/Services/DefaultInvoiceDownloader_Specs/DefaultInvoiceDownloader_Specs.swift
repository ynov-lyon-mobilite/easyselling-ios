//
//  DefaultInvoiceDownloader_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 05/12/2021.
//

import XCTest
@testable import easyselling

class DefaultInvoiceDownloader_Specs: XCTestCase {

    func test_Downloads_file_successfully() async {
        givenInvoiceDownloader(requestGenerator: FakeAuthorizedRequestGenerator(), imageCaller: DefaultImageCaller(urlSession: FakeUrlSession(localFile: .succeededFile)))
        await whenTryingToDownloadFile(id: "")
        thenFileImageIsNotEmpty()
    }

    func test_Throws_error_when_download_failed() async {
        givenInvoiceDownloader(requestGenerator: FakeAuthorizedRequestGenerator(), imageCaller: FailingImageCaller(withError: 404))
        await whenTryingToDownloadFile(id: "")
        thenError(is: .notFound)
    }

    private func givenInvoiceDownloader(requestGenerator: AuthorizedRequestGenerator, imageCaller: ImageCaller) {
        downloader = DefaultInvoiceDownloader(requestGenerator: requestGenerator, imageCaller: imageCaller)
    }

    private func whenTryingToDownloadFile(id: String) async {
        do {
            downloadedFile = try await downloader.downloadInvoiceFile(id: "1")
        } catch(let error) {
            self.error = error as? APICallerError
        }
    }

    private func thenFileImageIsNotEmpty() {
        XCTAssertNotNil(downloadedFile, "Image should not be nil")
    }

    private func thenError(is expected: APICallerError) {
        XCTAssertEqual(expected, error)
    }

    private var downloader: DefaultInvoiceDownloader!
    private var downloadedFile: UIImage!
    private var error: APICallerError!
}

class DefaultInvoiceFileInformationsGetter_Specs: XCTestCase {

    func test_Downloads_file_successfully() async {
        givenInvoiceDownloader(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: DefaultAPICaller(urlSession: FakeUrlSession(localFile: .succeededFile)))
        await whenTryingToGetInvoiceFile()
        thenFileTitle(is: "succeededFile")
        thenFileType(is: "jpg")
    }

    func test_Throws_error_when_request_failed() async {
        givenInvoiceDownloader(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: FailingAPICaller(withError: 404))
        await whenTryingToGetInvoiceFile()
        thenError(is: .notFound)
    }

    private func givenInvoiceDownloader(requestGenerator: AuthorizedRequestGenerator, apiCaller: APICaller) {
        downloader = DefaultInvoiceFileInformationsGetter(requestGenerator: requestGenerator, apiCaller: apiCaller)
    }

    private func whenTryingToGetInvoiceFile() async {
        do {
            invoiceFile = try await downloader.getInvoiceFile(of: "1")
        } catch(let error) {
            self.error = error as? APICallerError
        }
    }

    private func thenFileTitle(is expected: String) {
        XCTAssertEqual(expected, invoiceFile.title)
    }

    private func thenFileType(is expected: String) {
        XCTAssertTrue(invoiceFile.type.contains(expected))
    }

    private func thenError(is expected: APICallerError) {
        XCTAssertEqual(expected, error)
    }

    private var downloader: DefaultInvoiceFileInformationsGetter!
    private var invoiceFile: InvoiceFile!
    private var error: APICallerError!
}

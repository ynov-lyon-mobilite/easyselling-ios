//
//  DefaultFileUploader_Specs.swift
//  easysellingTests
//
//  Created by Maxence on 09/11/2021.
//

import XCTest
@testable import easyselling

class DefaultFileUploader_Specs: XCTestCase {

    func test_Generates_multipart_data_body() {
        let boundaryConstant = UUID().uuidString
        let filename = "sample.pdf"
        let filetype = "application/pdf"
        let fileData = "EMPTY_DATA".data(using: .utf8)!
        
        var expectedData = Data()
        expectedData.append("--\(boundaryConstant)\r\n".data(using: .utf8)!)
        expectedData.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        expectedData.append("Content-Type: \(filetype)\r\n\r\n".data(using: .utf8)!)
        expectedData.append(fileData)
        expectedData.append("\r\n".data(using: .utf8)!)
        expectedData.append("--\(boundaryConstant)--\r\n".data(using: .utf8)!)
        
        givenAccountCreator()
        whenGenerateBody(filename: filename, filetype: filetype, data: fileData, boundary: boundaryConstant)
        thenBody(is: expectedData, contentType: "multipart/form-data; boundary=\(boundaryConstant)")
    }
    
    func test_Creates_account_successfully() async {
        givenAccountCreator(body: "{ \"data\": { \"id\": \"AZ90JAPNDAIUBOAN\" } }")
        await whenUploadFile(filename: "sample.pdf", filetype: "application/pdf", data: Data())
        thenFile(is: UploadedFile(id: "AZ90JAPNDAIUBOAN"))
    }
    
    func test_Creates_account_failed_with_wrong_url() async {
        givenAccountCreator(error: .badRequest)
        await whenUploadFile(filename: "sample.pdf", filetype: "application/pdf", data: Data())
        thenErrorCode(is: 400)
        thenErrorMessage(is: "Une erreur est survenue")
    }
    
    func test_Creates_account_failed_with_forbiden_access() async {
        givenAccountCreator(error: .notFound)
        await whenUploadFile(filename: "sample.pdf", filetype: "application/pdf", data: Data())
        thenErrorCode(is: 404)
        thenErrorMessage(is: "Impossible de trouver ce que vous cherchez")
    }
    
    private func givenAccountCreator(body: String = "") {
        let urlSession = FakeUrlSession(with: body.data(using: .utf8)!)
        fileUploader = DefaultFileUploader(requestGenerator: FakeRequestGenerator(), urlSession: urlSession)
    }
    
    private func givenAccountCreator(error: APICallerError) {
        fileUploader = DefaultFileUploader(requestGenerator: FakeRequestGenerator(), urlSession: FakeUrlSession(error: error))
    }
    
    private func whenUploadFile(filename: String, filetype: String, data: Data) async {
        do {
            uploadedFile = try await fileUploader.upload(filename: filename, filetype: filetype, data: data)
        } catch (let error) {
            self.error = (error as! APICallerError)
        }
    }
    
    private func whenGenerateBody(filename: String, filetype: String, data: Data, boundary: String) {
        do {
            generatedBody = try fileUploader.generateBody(filename: filename, filetype: filetype, data: data, boundary: boundary)
        } catch (let error) {
            self.error = (error as! APICallerError)
        }
    }
    
    private func thenFile(is expected: UploadedFile) {
        XCTAssertEqual(expected, uploadedFile)
    }
    
    private func thenBody(is expected: Data, contentType: String) {
        XCTAssertEqual(expected, generatedBody.data)
        XCTAssertEqual(contentType, generatedBody.contentType)
    }
    
    private func thenErrorCode(is expected: Int) {
        XCTAssertEqual(expected, error.rawValue)
    }
    
    private func thenErrorMessage(is expected: String) {
        XCTAssertEqual(expected, error.errorDescription)
    }
    
    private var fileUploader: DefaultFileUploader!
    private var uploadedFile: UploadedFile!
    private var generatedBody: (data: Data, contentType: String)!
    private var error: APICallerError!
}

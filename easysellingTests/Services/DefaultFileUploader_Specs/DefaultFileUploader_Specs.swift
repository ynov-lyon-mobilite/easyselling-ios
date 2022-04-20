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
        
        givenFileUploader(apiCaller: SucceedingAPICaller())
        whenGenerateBody(filename: filename, filetype: filetype, data: fileData, boundary: boundaryConstant)
        thenBody(is: expectedData, contentType: "multipart/form-data; boundary=\(boundaryConstant)")
    }
    
    func test_Uploads_file_successfully() async {
        let apiCaller = DefaultAPICaller(urlSession: FakeUrlSession(localFile: .fileUploaderResponse))

        givenFileUploader(apiCaller: apiCaller)
        await whenUploadFile(filename: "sample.pdf", filetype: "application/pdf", data: Data())
        thenFile(is: UploadedFile(id: "AZ90JAPNDAIUBOAN", filename: "filaname.jpg", type: "image/jpeg"))
    }
    
    func test_Uploads_file_failed_with_bad_request() async {
        givenFileUploader(apiCaller: FailingAPICaller(withError: 400))
        await whenUploadFile(filename: "sample.pdf", filetype: "application/pdf", data: Data())
        thenErrorCode(is: 400)
        thenErrorMessage(is: APICallerError.internalServerError.errorDescription)
    }
    
    func test_Uploads_file_failed_with_not_found() async {
        givenFileUploader(apiCaller: FailingAPICaller(withError: 404))
        await whenUploadFile(filename: "sample.pdf", filetype: "application/pdf", data: Data())
        thenErrorCode(is: 404)
        thenErrorMessage(is: APICallerError.notFound.errorDescription)
    }
    
    private func givenFileUploader(apiCaller: APICaller) {
        fileUploader = DefaultFileUploader(requestGenerator: FakeAuthorizedRequestGenerator(), apiCaller: apiCaller)
    }
    
    private func whenUploadFile(filename: String, filetype: String, data: Data) async {
        do {
            let fileDTO = FileDTO(name: filename, type: filetype, data: data)
            uploadedFile = try await fileUploader.upload(fileDTO)
        } catch (let error) {
            self.error = (error as! APICallerError)
        }
    }
    
    private func whenGenerateBody(filename: String, filetype: String, data: Data, boundary: String) {
        let fileDTO = FileDTO(name: filename, type: filetype, data: data)
        do {
            generatedBody = try fileUploader.generateBody(fileDTO, boundary: boundary)
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
    
    private func thenErrorMessage(is expected: String?) {
        XCTAssertEqual(expected, error.errorDescription)
    }
    
    private var fileUploader: DefaultFileUploader!
    private var uploadedFile: UploadedFile!
    private var generatedBody: (data: Data, contentType: String)!
    private var error: APICallerError!
}

//
//  DefaultFileUploader.swift
//  easyselling
//
//  Created by Maxence on 09/11/2021.
//

import Foundation

protocol FileUploader {
    func upload(filename: String, filetype: String, data: Data) async throws -> UploadedFile
}

final class DefaultFileUploader: FileUploader {
    private var requestGenerator: RequestGenerator
    private var apiCaller: APICaller
    
    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(), urlSession: URLSessionProtocol = URLSession.shared) {
        self.requestGenerator = requestGenerator
        self.apiCaller = DefaultAPICaller(urlSession: urlSession)
    }
    
    func upload(filename: String, filetype: String, data: Data) async throws -> UploadedFile {
        let (body, contentType) = try generateBody(filename: filename, filetype: filetype, data: data)

        var urlRequest = try requestGenerator
            .generateRequest(endpoint: .files, method: .POST, headers: ["Content-Type": contentType])
        urlRequest.httpBody = body

        return try await apiCaller.call(urlRequest, decodeType: UploadedFile.self)
    }
    
    func generateBody(filename: String, filetype: String, data: Data, boundary: String = UUID().uuidString) throws -> (Data, String) {
        let contentType = "multipart/form-data; boundary=" + boundary

        guard let boundaryStart = "--\(boundary)\r\n".data(using: .utf8),
              let boundaryEnd = "--\(boundary)--\r\n".data(using: .utf8),
              let contentDispositionString = "Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8),
              let contentTypeString = "Content-Type: \(filetype)\r\n\r\n".data(using: .utf8),
              let separator = "\r\n".data(using: .utf8) else {
                  throw APICallerError.requestGenerationError
              }

        var body = Data()
        body.append(boundaryStart)
        body.append(contentDispositionString)
        body.append(contentTypeString)
        body.append(data)
        body.append(separator)
        body.append(boundaryEnd)

        return (body, contentType)
    }
}

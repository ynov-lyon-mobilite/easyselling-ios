//
//  DefaultFileUploader.swift
//  easyselling
//
//  Created by Maxence on 09/11/2021.
//

import Foundation

protocol FileUploader {
    func upload(_ fileDTO: FileDTO) async throws -> UploadedFile
}

final class DefaultFileUploader: FileUploader {
    private var requestGenerator: RequestGenerator
    private var apiCaller: APICaller

    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    func upload(_ fileDTO: FileDTO) async throws -> UploadedFile {
        let (body, contentType) = try generateBody(fileDTO)

        var urlRequest = try requestGenerator
            .generateRequest(endpoint: .files, method: .POST, headers: ["Content-Type": contentType],
                             pathKeysValues: [:], queryParameters: nil)
        urlRequest.httpBody = body

        return try await apiCaller.call(urlRequest, decodeType: UploadedFile.self)
    }

    func generateBody(_ fileDTO: FileDTO, boundary: String = UUID().uuidString) throws -> (Data, String) {
        let contentType = "multipart/form-data; boundary=" + boundary

        guard let boundaryStart = "--\(boundary)\r\n".data(using: .utf8),
              let boundaryEnd = "--\(boundary)--\r\n".data(using: .utf8),
              let contentDispositionString = "Content-Disposition: form-data; name=\"file\"; filename=\"\(fileDTO.name)\"\r\n".data(using: .utf8),
              let contentTypeString = "Content-Type: \(fileDTO.type)\r\n\r\n".data(using: .utf8),
              let separator = "\r\n".data(using: .utf8) else {
                  throw APICallerError.requestGenerationError
              }

        var body = Data()
        body.append(boundaryStart)
        body.append(contentDispositionString)
        body.append(contentTypeString)
        body.append(fileDTO.data)
        body.append(separator)
        body.append(boundaryEnd)

        return (body, contentType)
    }
}

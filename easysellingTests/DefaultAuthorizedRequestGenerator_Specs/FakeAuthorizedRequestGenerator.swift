//
//  FakeAuthorizedRequestGenerator.swift
//  easysellingTests
//
//  Created by Théo Tanchoux on 24/11/2021.
//

import Foundation
@testable import easyselling

class FakeAuthorizedRequestGenerator: AuthorizedRequestGenerator {
    
    private let requestGenerator: RequestGenerator
    
    init(requestGenerator: RequestGenerator = FakeRequestGenerator()) {
        self.requestGenerator = requestGenerator
    }
    
    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String : String]) async throws -> URLRequest {
        var request = try requestGenerator.generateRequest(endpoint: endpoint, method: method, headers: headers)

        request.addValue("Bearer \(updatedAccessToken)", forHTTPHeaderField: "authorization")

        return request
    }

    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod,
                                       body: T?,headers: [String : String]) async throws -> URLRequest {
        var request = try requestGenerator.generateRequest(endpoint: endpoint, method: method, body: body, headers: headers)

        request.addValue("Bearer \(updatedAccessToken)", forHTTPHeaderField: "authorization")

        return request
    }
    
    private var updatedAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPbmxpbmUgSldUIEJ1aWxkZXIiLCJpYXQiOjI1NTA5Nzc4NjIsImV4cCI6MjU1MDk3Nzg2MiwiYXVkIjoid3d3LmV4YW1wbGUuY29tIiwic3ViIjoianJvY2tldEBleGFtcGxlLmNvbSJ9.ENKI9xGTd8ytjIcR-WU4ew1OjosULqgzznYcwneY4_s"
}


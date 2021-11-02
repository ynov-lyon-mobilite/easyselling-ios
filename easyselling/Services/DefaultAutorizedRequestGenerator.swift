//
//  DefaultAutorizedRequestGenerator.swift
//  easyselling
//
//  Created by Maxence on 02/11/2021.
//

import Foundation

protocol AutorizedRequestGenerator {
    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String: String]) async throws -> URLRequest
    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod,
                                       body: T?, headers: [String: String]) async throws -> URLRequest
}

class DefaultAutorizedRequestGenerator: AutorizedRequestGenerator {
    private let requestGenerator: RequestGenerator
    private let tokenManager: TokenManager
    
    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(), tokenManager: TokenManager = DefaultTokenManager.shared) {
        self.requestGenerator = requestGenerator
        self.tokenManager = tokenManager
    }
    
    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String : String]) async throws -> URLRequest {
        var request = try requestGenerator.generateRequest(endpoint: endpoint, method: method, headers: headers)
        
        request.addValue("Bearer \(tokenManager.accessToken!)", forHTTPHeaderField: "authorization")
        
        return request
    }

    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod,
                                       body: T?,headers: [String : String]) async throws -> URLRequest {
        var request = try requestGenerator.generateRequest(endpoint: endpoint, method: method, body: body, headers: headers)
        
        request.addValue("Bearer \(tokenManager.accessToken!)", forHTTPHeaderField: "authorization")
        
        return request
    }
}

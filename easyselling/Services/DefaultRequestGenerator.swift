//
//  DefaultRequestGenerator.swift
//  easyselling
//
//  Created by Maxence on 11/10/2021.
//

import Foundation

protocol RequestGenerator {
    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod,
                                       body: T?, headers: [String: String]) throws -> URLRequest
    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String: String]) throws -> URLRequest
}

class DefaultRequestGenerator: RequestGenerator {
    private var jsonEncoder = JSONEncoder()
    private var fixHeaders: [String: String] = ["Content-Type": "application/json"]

    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod = .GET,
                                       body: T?, headers: [String: String]) throws -> URLRequest {
        guard let encodedBody = try? jsonEncoder.encode(body) else {
            throw HTTPError.requestGenerationError
        }
        
        var request = try generateRequest(endpoint: endpoint, method: method, headers: headers)
        request.httpBody = encodedBody
        
        return request
    }

    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String: String]) throws -> URLRequest {
        guard let url = URL(string: endpoint.urlString) else {
            throw HTTPError.requestGenerationError
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        fixHeaders
            .merging(headers) { _, dynamic in
                return dynamic
            }.forEach {
                request.addValue($1, forHTTPHeaderField: $0)
            }

        return request
    }
}

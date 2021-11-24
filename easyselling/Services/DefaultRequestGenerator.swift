//
//  DefaultRequestGenerator.swift
//  easyselling
//
//  Created by Maxence on 11/10/2021.
//

import Foundation

protocol RequestGenerator {
    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod,
                                       body: T?, headers: [String: String],
                                       queryParameters: [String: Any]) throws -> URLRequest
    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod,
                         headers: [String: String], queryParameters: [String: Any]) throws -> URLRequest
}

extension RequestGenerator {
    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod,
                                       body: T?, headers: [String: String] = [:],
                                       queryParameters: [String: Any] = [:]) throws -> URLRequest {
        return try generateRequest(endpoint: endpoint, method: method, body: body, headers: headers, queryParameters: queryParameters)
    }

    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod,
                         headers: [String: String] = [:], queryParameters: [String: Any] = [:]) throws -> URLRequest {
        return try generateRequest(endpoint: endpoint, method: method, headers: headers, queryParameters: queryParameters)
    }
}

class DefaultRequestGenerator: RequestGenerator {
    private var tokenManager: TokenManager

    init(tokenManager: TokenManager = DefaultTokenManager.shared) {
        self.tokenManager = tokenManager
    }

    private var jsonEncoder = JSONEncoder()
    private var fixHeaders: [String: String] = ["Content-Type": "application/json"]

    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod = .GET,
                                       body: T?, headers: [String: String],
                                       queryParameters: [String: Any]) throws -> URLRequest {
        guard let encodedBody = try? jsonEncoder.encode(body) else {
            throw APICallerError.encodeError
        }

        var request = try generateRequest(endpoint: endpoint, method: method,
                                          headers: headers, queryParameters: queryParameters)
        request.httpBody = encodedBody

        return request
    }

    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod,
                         headers: [String: String], queryParameters: [String: Any]) throws -> URLRequest {
        guard let url = URL(string: endpoint.urlString) else {
            throw APICallerError.requestGenerationError
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        fixHeaders
            .merging(headers) { _, dynamic in
                return dynamic
            }.forEach {
                request.addValue($1, forHTTPHeaderField: $0)
            }

//        if queryParameters != [:], var component = URLComponents(string: urlString) {
//            component.queryItems = queryParameters.keys.map({ URLQueryItem(name: $0, value: queryParameters[$0]) })
//
//            return component.url
//        }

        return request
    }
}

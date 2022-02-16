//
//  DefaultRequestGenerator.swift
//  easyselling
//
//  Created by Maxence on 11/10/2021.
//

import Foundation

protocol RequestGenerator {
    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod, body: T?, headers: [String: String],
                                       pathKeysValues: [String: String], queryParameters: [String: String]?) throws -> URLRequest
    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String: String],
                         pathKeysValues: [String: String], queryParameters: [String: String]?) throws -> URLRequest
}

class DefaultRequestGenerator: RequestGenerator {
    private var tokenManager: TokenManager

    init(tokenManager: TokenManager = DefaultTokenManager.shared) {
        self.tokenManager = tokenManager
    }

    private var jsonEncoder = JSONEncoder()
    private var fixHeaders: [String: String] = ["Content-Type": "application/json"]

    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod = .GET, body: T?, headers: [String: String],
                                       pathKeysValues: [String: String], queryParameters: [String: String]?) throws -> URLRequest {
        guard let encodedBody = try? jsonEncoder.encode(body) else {
            throw APICallerError.encodeError
        }

        var request = try generateRequest(endpoint: endpoint, method: method, headers: headers,
                                          pathKeysValues: pathKeysValues, queryParameters: queryParameters)
        request.httpBody = encodedBody

        return request
    }

    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String: String],
                         pathKeysValues: [String: String], queryParameters: [String: String]?) throws -> URLRequest {
        let url = try computeURL(endpoint: endpoint, pathKeysValues: pathKeysValues, queryParameters: queryParameters)

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

    private func computeURL(endpoint: HTTPEndpoint, pathKeysValues: [String: String], queryParameters: [String: String]?) throws -> URL {
        guard var urlString = endpoint.url?.absoluteString else {
            throw APICallerError.requestGenerationError
        }

        pathKeysValues.keys.forEach { key in
            guard let value = pathKeysValues[key] else { return }
            urlString = urlString.replacingOccurrences(of: ":\(key)", with: value)
        }

        guard let url = URL(string: urlString) else {
            throw APICallerError.requestGenerationError
        }

        if let queryParameters = queryParameters, !queryParameters.keys.isEmpty, var component = URLComponents(string: urlString) {
            component.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }

            return component.url ?? url
        }

        return url
    }
}

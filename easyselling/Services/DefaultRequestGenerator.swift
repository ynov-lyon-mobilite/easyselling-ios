//
//  RequestGenerator.swift
//  easyselling
//
//  Created by Maxence on 11/10/2021.
//

import Foundation

protocol RequestGenerator {
    func generateRequest<T: Encodable>(endpoint: String, method: HTTPMethod,
                                       body: T?, headers: [String: String]) -> URLRequest?
    func generateRequest(endpoint: String, method: HTTPMethod, headers: [String: String]) -> URLRequest?
}

class DefaultRequestGenerator: RequestGenerator {
    private var jsonEncoder = JSONEncoder()
    private var fixHeaders: [String: String] = ["Content-Type": "application/json"]

    func generateRequest<T: Encodable>(endpoint: String, method: HTTPMethod = .GET,
                                       body: T?, headers: [String: String] = [:]) -> URLRequest? {
        guard var request = generateRequest(endpoint: endpoint, method: method, headers: headers),
              let encodedBody = try? jsonEncoder.encode(body) else {
            return nil
        }

        request.httpBody = encodedBody

        return request
    }

    func generateRequest(endpoint: String, method: HTTPMethod, headers: [String: String]) -> URLRequest? {
        guard let url = URL(string: endpoint) else {
            return nil
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

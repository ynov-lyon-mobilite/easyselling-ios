//
//  FakeRequestGenerator.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 16/10/2021.
//

import Foundation
@testable import easyselling

class FakeRequestGenerator: RequestGenerator {    
    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod, body: T?,
                                       headers: [String : String], pathKeysValues: [String: String], queryParameters: [QueryParameter]?) -> URLRequest {
        var request = generateRequest(endpoint: endpoint, method: method, headers: headers, pathKeysValues: pathKeysValues, queryParameters: queryParameters)
        request.httpBody = try! JSONEncoder().encode(body)

        return request
    }
    
    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod,
                         headers: [String : String], pathKeysValues: [String: String], queryParameters: [QueryParameter]?) -> URLRequest {
        var urlString = endpoint.url!.absoluteString
        pathKeysValues.keys.forEach { key in
            guard let value = pathKeysValues[key] else { return }
            urlString = urlString.replacingOccurrences(of: ":\(key)", with: value)
        }

        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = method.rawValue
        
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}


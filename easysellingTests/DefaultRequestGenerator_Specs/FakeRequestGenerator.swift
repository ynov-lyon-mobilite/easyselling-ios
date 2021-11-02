//
//  FakeRequestGenerator.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 16/10/2021.
//

import Foundation
@testable import easyselling

class FakeRequestGenerator: RequestGenerator {
    
    init(_ url: String) {
        self.url = url
    }
    
    private var url: String
    
    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod,
                                       body: T?, headers: [String : String]) -> URLRequest {
        var request = URLRequest(url: URL(string: endpoint.urlString)!)
        request.httpMethod = method.rawValue
        request.httpBody = try! JSONEncoder().encode(body)
        
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String : String]) -> URLRequest {
        var request = URLRequest(url: URL(string: endpoint.urlString)!)
        request.httpMethod = method.rawValue
        
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}


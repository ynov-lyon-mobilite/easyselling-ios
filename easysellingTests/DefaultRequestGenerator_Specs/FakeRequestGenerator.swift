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
        return URLRequest(url: URL(string: url)!)
    }
    
    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String : String]) -> URLRequest {
        return URLRequest(url: URL(string: url)!)
    }
}


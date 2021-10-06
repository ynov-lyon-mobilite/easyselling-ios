//
//  NetworkService_Specs.swift
//  easysellingTests
//
//  Created by Maxence on 06/10/2021.
//

import XCTest
@testable import easyselling

class NetworkService_Specs: XCTestCase {
    
    func test_GenerateRequest() {
        var request = URLRequest(url: URL(string: "https://easyselling.maxencemottard.com/api/v1/users/profile")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue
        
        givenService(baseUrl: "https://easyselling.maxencemottard.com/api/v1")
        whenGenerateRequest(endpoint: "/users/profile", method: .POST, headers: [:])
        thenRequest(is: request)
    }
    
    func test_GenerateRequestFailed() {
        var request = URLRequest(url: URL(string: "easyselling")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue
        
        givenService(baseUrl: "https://easyselling.maxencemottard.com/api/v1")
        whenGenerateRequest(endpoint: "/users/profile", method: .POST, headers: [:])
        thenRequest(is: request)
    }

    private func givenService(baseUrl: String) {
        networkService = NetworkService(baseUrl: baseUrl)
    }
    
    private func whenGenerateRequest(endpoint: String, method: HTTPMethod, headers: [String: String]) {
        request = networkService.generateRequest(withoutBody: endpoint, method: method, headers: headers)
    }
    
    private func whenGenerateRequest(endpoint: String, method: HTTPMethod, headers: [String: String], body: Encodable) {
        request = networkService.generateRequest(withoutBody: endpoint, method: method, headers: headers)
    }
    
    private func thenRequest(is expectedRequest: URLRequest?) {
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.httpBody, expectedRequest?.httpBody)
        XCTAssertEqual(request?.url, expectedRequest?.url)
        XCTAssertEqual(request?.httpMethod, expectedRequest?.httpMethod)
        XCTAssertEqual(request?.allHTTPHeaderFields, expectedRequest?.allHTTPHeaderFields)
    }

    private var networkService: NetworkService!
    private var request: URLRequest?
}

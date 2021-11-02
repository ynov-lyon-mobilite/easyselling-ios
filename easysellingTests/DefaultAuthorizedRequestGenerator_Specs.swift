//
//  DefaultAuthorizedRequestGenerator_Specs.swift
//  easysellingTests
//
//  Created by Maxence on 02/11/2021.
//

import Foundation
import XCTest
@testable import easyselling

class DefaultAuthorizedRequestGenerator_Specs: XCTestCase {
    
    func test_Injects_successfully() async {
        var request = URLRequest(url: URL(string: "https://easyselling.maxencemottard.com/items/vehicles")!)
        request.addValue("Bearer \(updatedAccessToken)", forHTTPHeaderField: "authorization")
        request.httpMethod = HTTPMethod.GET.rawValue
        
        tokenManager.accessToken = updatedAccessToken

        givenService()
        await whenGenerateRequest(endpoint: .vehicles, method: .GET, headers: [:])
        thenRequest(is: request)
    }
    
    func test_Injects_successfully_with_body() async {
        let body = "BODY"
        var request = URLRequest(url: URL(string: "https://easyselling.maxencemottard.com/items/vehicles")!)
        request.addValue("Bearer \(updatedAccessToken)", forHTTPHeaderField: "authorization")
        request.httpBody = try! JSONEncoder().encode(body)
        
        tokenManager.accessToken = updatedAccessToken

        givenService()
        await whenGenerateRequestWithBody(endpoint: .vehicles, method: .GET, body: body, headers: [:])
        thenRequest(is: request)
    }
    
    private func givenService() {
        let requestGenerator = FakeRequestGenerator("https://google.com")
        self.requestGenerator = DefaultAutorizedRequestGenerator(requestGenerator: requestGenerator, tokenManager: tokenManager)
    }
    
    private func whenGenerateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String: String]) async {
        do {
            self.request = try await requestGenerator.generateRequest(endpoint: endpoint, method: method, headers: headers)
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func whenGenerateRequestWithBody<T: Encodable>(
        endpoint: HTTPEndpoint,
        method: HTTPMethod,
        body: T,
        headers: [String: String]) async {
            do {
                self.request = try await requestGenerator.generateRequest(endpoint: endpoint, method: method, body: body, headers: headers)
            } catch(let error) {
                self.error = (error as! APICallerError)
            }
        }

    private func whenNoLongerInterested() {
        requestGenerator = nil
    }

    private func thenRequest(is expectedRequest: URLRequest) {
        XCTAssertNotNil(request)
        XCTAssertEqual(request.url, expectedRequest.url)
        XCTAssertEqual(request.httpMethod, expectedRequest.httpMethod)
        XCTAssertEqual(request.allHTTPHeaderFields, expectedRequest.allHTTPHeaderFields)
        XCTAssertEqual(request.httpBody, expectedRequest.httpBody)
    }

    private func thenRequestWithBody(is expectedRequest: URLRequest) {
        XCTAssertNotNil(request)
        XCTAssertEqual(request.url, expectedRequest.url)
        XCTAssertEqual(request.httpMethod, expectedRequest.httpMethod)
        XCTAssertEqual(request.allHTTPHeaderFields, expectedRequest.allHTTPHeaderFields)
        XCTAssertEqual(String(data: request.httpBody!, encoding: .utf8),
                       String(data: expectedRequest.httpBody!, encoding: .utf8))
    }
    
    private var requestGenerator: AutorizedRequestGenerator!
    private var request: URLRequest!
    private var error: APICallerError!
    private var tokenManager = FakeTokenManager()
    
    private var updatedAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPbmxpbmUgSldUIEJ1aWxkZXIiLCJpYXQiOjI1NTA5Nzc4NjIsImV4cCI6MjU1MDk3Nzg2MiwiYXVkIjoid3d3LmV4YW1wbGUuY29tIiwic3ViIjoianJvY2tldEBleGFtcGxlLmNvbSJ9.ENKI9xGTd8ytjIcR-WU4ew1OjosULqgzznYcwneY4_s"
}

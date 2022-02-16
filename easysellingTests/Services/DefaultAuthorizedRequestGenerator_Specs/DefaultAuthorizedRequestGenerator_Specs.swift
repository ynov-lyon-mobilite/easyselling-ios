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
    
    func test_Generates_request_with_token_in_header() async {
        var request = URLRequest(url: URL(string: "https://api.easyselling.maxencemottard.com/items/vehicles")!)
        request.addValue("Bearer \(updatedAccessToken)", forHTTPHeaderField: "authorization")
        request.httpMethod = HTTPMethod.GET.rawValue

        givenService(accessTokenIsExpired: false, accessToken: updatedAccessToken, refreshToken: "FAKE_REFRESH_TOKEN")
        await whenGenerateRequest(endpoint: .vehicles, method: .GET, headers: [:])
        thenRequest(is: request)
    }

    func test_Generates_Request_With_Headers_and_token_in_header() async {
        let body = "BODY"
        var request = URLRequest(url: URL(string: "https://api.easyselling.maxencemottard.com/items/vehicles")!)
        request.addValue("Bearer \(updatedAccessToken)", forHTTPHeaderField: "authorization")
        request.addValue("value", forHTTPHeaderField: "teast-haeder")
        request.httpBody = try! JSONEncoder().encode(body)

        givenService(accessTokenIsExpired: false, accessToken: updatedAccessToken, refreshToken: "FAKE_REFRESH_TOKEN")
        await whenGenerateRequestWithBody(endpoint: .vehicles, method: .GET, body: body, headers: ["teast-haeder": "value"])
        thenRequestWithBody(is: request)
    }

    func test_Generates_Request_With_Path_keys_values_and_token_in_header() async {
        var request = URLRequest(url: URL(string: "https://api.easyselling.maxencemottard.com/items/vehicles/myVehicle")!)
        request.addValue("Bearer \(updatedAccessToken)", forHTTPHeaderField: "authorization")

        givenService(accessTokenIsExpired: false, accessToken: updatedAccessToken, refreshToken: "FAKE_REFRESH_TOKEN")
        await whenGenerateRequest(endpoint: .vehicleId, method: .GET, headers: [:], pathKeysValues: ["vehicleId": "myVehicle"])
        thenRequest(is: request)
    }
    
    func test_Generates_request_with_token_in_header_after_refresh_token() async {
        var request = URLRequest(url: URL(string: "https://api.easyselling.maxencemottard.com/items/vehicles")!)
        request.addValue("Bearer \(updatedAccessToken)", forHTTPHeaderField: "authorization")
        
        givenService(accessTokenIsExpired: true, accessToken: outdatedAccessToken, refreshToken: "REFRESH_TOKEN")
        await whenGenerateRequest(endpoint: .vehicles, method: .GET, headers: [:])
        thenRequest(is: request)
    }
    
    func test_Generates_Request_With_Headers_and_token_in_header_after_refresh_token() async {
        let body = "BODY"
        var request = URLRequest(url: URL(string: "https://api.easyselling.maxencemottard.com/items/vehicles")!)
        request.addValue("Bearer \(updatedAccessToken)", forHTTPHeaderField: "authorization")
        request.httpBody = try! JSONEncoder().encode(body)
        
        givenService(accessTokenIsExpired: true, accessToken: outdatedAccessToken, refreshToken: "REFRESH_TOKEN")
        await whenGenerateRequestWithBody(endpoint: .vehicles, method: .GET, body: body, headers: [:])
        thenRequestWithBody(is: request)
    }
    
    func test_Throws_error_after_refresh_token_failure() async {
        var request = URLRequest(url: URL(string: "https://api.easyselling.maxencemottard.com/items/vehicles")!)
        request.addValue("Bearer \(updatedAccessToken)", forHTTPHeaderField: "authorization")
        
        let tokenManager = FakeTokenManager(accessTokenIsExpired: true, accessToken: "ACCESS_TOKEN", refreshToken: "REFRESH_TOKEN")
        
        givenService(tokenManager: tokenManager, tokenRefreshor: FailingTokenRefreshor(error: .badRequest))
        await whenGenerateRequest(endpoint: .vehicles, method: .GET, headers: [:])
        thenError(is: .badRequest)
    }
    
    func test_Throws_error_with_empty_access_and_refresh_token() async {
        var request = URLRequest(url: URL(string: "https://api.easyselling.maxencemottard.com/items/vehicles")!)
        request.addValue("Bearer \(updatedAccessToken)", forHTTPHeaderField: "authorization")
        
        givenService(tokenManager: FakeTokenManager(), tokenRefreshor: FailingTokenRefreshor(error: .badRequest))
        await whenGenerateRequest(endpoint: .vehicles, method: .GET, headers: [:])
        thenError(is: .unauthorized)
    }
    
    private func givenService(accessTokenIsExpired: Bool, accessToken: String?, refreshToken: String?) {
        let requestGenerator = FakeRequestGenerator()
        let tokenManager = FakeTokenManager(accessTokenIsExpired: accessTokenIsExpired,
                                            accessToken: accessToken,
                                            refreshToken: refreshToken)
        self.requestGenerator = DefaultAuthorizedRequestGenerator(
            requestGenerator: requestGenerator, tokenManager: tokenManager,
            tokenRefreshor: SucceedingTokenRefreshor(accessToken: updatedAccessToken))
    }
    
    private func givenService(tokenManager: TokenManager, tokenRefreshor: TokenRefreshor) {
        let requestGenerator = FakeRequestGenerator()
        self.requestGenerator = DefaultAuthorizedRequestGenerator(requestGenerator: requestGenerator, tokenManager: tokenManager,
                                                                 tokenRefreshor: tokenRefreshor)
    }
    
    private func whenGenerateRequest(endpoint: HTTPEndpoint, method: HTTPMethod,
                                     headers: [String: String] = [:], pathKeysValues: [String: String] = [:]) async {
        do {
            self.request = try await requestGenerator.generateRequest(endpoint: endpoint, method: method, headers: headers, pathKeysValues: pathKeysValues, queryParameters: nil)
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func whenGenerateRequestWithBody<T: Encodable>(
        endpoint: HTTPEndpoint,
        method: HTTPMethod,
        body: T,
        headers: [String: String],
        pathKeysValues: [String: String] = [:]) async {
            do {
                self.request = try await requestGenerator.generateRequest(endpoint: endpoint, method: method, body: body, headers: headers, pathKeysValues: pathKeysValues, queryParameters: nil)
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
        XCTAssertNil(error)
    }

    private func thenRequestWithBody(is expectedRequest: URLRequest) {
        XCTAssertNotNil(request)
        XCTAssertEqual(request.url, expectedRequest.url)
        XCTAssertEqual(request.httpMethod, expectedRequest.httpMethod)
        XCTAssertEqual(request.allHTTPHeaderFields, expectedRequest.allHTTPHeaderFields)
        XCTAssertEqual(String(data: request.httpBody!, encoding: .utf8),
                       String(data: expectedRequest.httpBody!, encoding: .utf8))
        XCTAssertNil(error)
    }
    
    private func thenError(is expected: APICallerError) {
        XCTAssertEqual(expected, error)
        XCTAssertNil(request)
    }
    
    private var requestGenerator: AuthorizedRequestGenerator!
    private var request: URLRequest!
    private var error: APICallerError!
    
    private let outdatedAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPbmxpbmUgSldUIEJ1aWxkZXIiLCJpYXQiOjE2MzU4MzMwOTAsImV4cCI6MTYwNDI5NzA5MCwiYXVkIjoid3d3LmV4YW1wbGUuY29tIiwic3ViIjoianJvY2tldEBleGFtcGxlLmNvbSJ9.E3KPcWx5_rzlyThc7s-EKFQPLu6xkXv7TX5RbpIHINY"
    
    private var updatedAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPbmxpbmUgSldUIEJ1aWxkZXIiLCJpYXQiOjI1NTA5Nzc4NjIsImV4cCI6MjU1MDk3Nzg2MiwiYXVkIjoid3d3LmV4YW1wbGUuY29tIiwic3ViIjoianJvY2tldEBleGFtcGxlLmNvbSJ9.ENKI9xGTd8ytjIcR-WU4ew1OjosULqgzznYcwneY4_s"
}

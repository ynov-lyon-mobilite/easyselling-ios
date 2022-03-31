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
        var request = URLRequest(url: URL(string: "https://api.easyselling.maxencemottard.com/vehicles")!)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
        request.httpMethod = HTTPMethod.GET.rawValue

        givenService(firebaseAuthProvider: SucceedingFirebaseAuthProvider(isAuthenticated: true))
        await whenGenerateRequest(endpoint: .vehicles, method: .GET, headers: [:])
        thenRequest(is: request)
    }

    func test_Generates_Request_With_Headers_and_token_in_header() async {
        let body = "BODY"
        var request = URLRequest(url: URL(string: "https://api.easyselling.maxencemottard.com/vehicles")!)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
        request.addValue("value", forHTTPHeaderField: "teast-haeder")
        request.httpBody = try! JSONEncoder().encode(body)

        givenService(firebaseAuthProvider: SucceedingFirebaseAuthProvider(isAuthenticated: true))
        await whenGenerateRequestWithBody(endpoint: .vehicles, method: .GET, body: body, headers: ["teast-haeder": "value"])
        thenRequestWithBody(is: request)
    }

    func test_Generates_Request_With_Path_keys_values_and_token_in_header() async {
        var request = URLRequest(url: URL(string: "https://api.easyselling.maxencemottard.com/vehicles/myVehicle")!)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")

        givenService(firebaseAuthProvider: SucceedingFirebaseAuthProvider(isAuthenticated: true))
        await whenGenerateRequest(endpoint: .vehicleId, method: .GET, headers: [:], pathKeysValues: ["vehicleId": "myVehicle"])
        thenRequest(is: request)
    }
    
    
    func test_Throws_error_with_empty_access_token() async {
        var request = URLRequest(url: URL(string: "https://api.easyselling.maxencemottard.com/vehicles")!)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")

        givenService(firebaseAuthProvider: SucceedingFirebaseAuthProvider(isAuthenticated: false))
        await whenGenerateRequest(endpoint: .vehicles, method: .GET, headers: [:])
        thenError(is: .unauthorized)
    }
    
    private func givenService(firebaseAuthProvider: FirebaseAuthProvider) {
        self.requestGenerator = DefaultAuthorizedRequestGenerator(
            requestGenerator: FakeRequestGenerator(),
            firebaseAuthProvider: firebaseAuthProvider
        )
    }
    
    private func whenGenerateRequest(
        endpoint: HTTPEndpoint,
        method: HTTPMethod,
        headers: [String: String] = [:],
        pathKeysValues: [String: String] = [:]) async
    {
        do {
            self.request = try await requestGenerator.generateRequest(
                endpoint: endpoint,
                method: method,
                headers: headers,
                pathKeysValues: pathKeysValues,
                queryParameters: nil
            )
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func whenGenerateRequestWithBody<T: Encodable>(
        endpoint: HTTPEndpoint,
        method: HTTPMethod,
        body: T,
        headers: [String: String],
        pathKeysValues: [String: String] = [:]
    ) async {
            do {
                self.request = try await requestGenerator.generateRequest(
                    endpoint: endpoint,
                    method: method,
                    body: body,
                    headers: headers,
                    pathKeysValues: pathKeysValues,
                    queryParameters: nil
                )
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

    private let accessToken = "MY_ACCESS_TOKEN"
}

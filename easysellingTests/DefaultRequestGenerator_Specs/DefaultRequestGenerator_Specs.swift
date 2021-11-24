//
//  RequestGenerator_Specs.swift
//  easysellingTests
//
//  Created by Maxence on 06/10/2021.
//

import XCTest
@testable import easyselling

class DefaultRequestGenerator_Specs: XCTestCase {

    func test_Generates_Request() {
        var request = URLRequest(url: URL(string: "https://easyselling.maxencemottard.com/users")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue

        givenService()
        whenGenerateRequest(endpoint: .users, method: .POST, headers: [:])
        thenRequest(is: request)
    }

    func test_Generates_Request_With_Headers() {
        var request = URLRequest(url: URL(string: "https://easyselling.maxencemottard.com/users")!)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("With tested value", forHTTPHeaderField: "test-header")
        request.addValue("With another value", forHTTPHeaderField: "sedond-header")

        givenService()
        whenGenerateRequest(endpoint: .users, method: .POST,
                            headers: ["test-header": "With tested value", "sedond-header": "With another value"])
        thenRequest(is: request)
    }

    func test_Generates_Request_With_Query_Parameters() {
        var request = URLRequest(url: URL(string: "https://easyselling.maxencemottard.com/users/vehicles/ABCD")!)
        request.httpMethod = HTTPMethod.POST.rawValue

        givenService()
        whenGenerateRequest(endpoint: .users, method: .POST, headers: [:], queryParameteers: [

        ])
        thenRequest(is: request)
    }

    func test_Generates_Request_With_Body() {
        let body = "BODY"

        var request = URLRequest(url: URL(string: "https://easyselling.maxencemottard.com/users")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue
        request.httpBody = try! JSONEncoder().encode(body)

        givenService()
        whenGenerateRequestWithBody(endpoint: .users, method: .POST, body: body, headers: [:])
        thenRequestWithBody(is: request)
    }
    
    func test_JSON_encode_failure() {
        let body = Double.infinity

        givenService()
        whenGenerateRequestWithBody(endpoint: .users, method: .POST, body: body, headers: [:])
        XCTAssertEqual(APICallerError.encodeError, error)
    }

    func test_Deinit_when_no_longer_interested() {
        givenService()
        whenGenerateRequest(endpoint: .users, method: .POST, headers: [:])
        whenNoLongerInterested()

        XCTAssertNil(requestGenerator)
    }

    //  Implement later
//    func test_Generates_Request_With_Encodable_Body() {
//        let body = TestEncodable(argument: "MyArgument")
//
//        expectedRequest = URLRequest(url: URL(string: "https://easyselling.maxencemottard.com/api/v1/users/profile")!)
//        expectedRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        expectedRequest.httpMethod = HTTPMethod.POST.rawValue
//
//        givenService()
//        whenGenerateRequestWithBody(
//            endpoint: "https://easyselling.maxencemottard.com/api/v1/users/profile",
//            method: .POST, body: body, headers: [:])
//        thenRequestWithBody(is: expectedRequest)
//    }

    private func givenService() {
        requestGenerator = DefaultRequestGenerator()
    }

    private func whenGenerateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String: String]) {
        do {
            self.request = try requestGenerator.generateRequest(endpoint: endpoint, method: method, headers: headers)
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func whenGenerateRequestWithBody<T: Encodable>(
        endpoint: HTTPEndpoint,
        method: HTTPMethod,
        body: T,
        headers: [String: String]) {
            do {
                self.request = try requestGenerator.generateRequest(endpoint: endpoint, method: method, body: body, headers: headers)
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

    private var requestGenerator: DefaultRequestGenerator!
    private var request: URLRequest!
    private var error: APICallerError!
}

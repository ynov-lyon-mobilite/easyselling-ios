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
        whenGenerateRequest(endpoint: .users, method: .POST)
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

    func test_Generates_Request_and_override_content_type_set_to_JSON() {
        var request = URLRequest(url: URL(string: "https://easyselling.maxencemottard.com/users")!)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.addValue("application/xml", forHTTPHeaderField: "Content-Type")

        givenService()
        whenGenerateRequest(endpoint: .users, method: .POST, headers: ["Content-Type": "application/xml"])
        thenRequest(is: request)
    }

    func test_Generates_Request_With_Path_keys_values() {
        let body = "BODY"

        var request = URLRequest(url: URL(string: "https://easyselling.maxencemottard.com/items/vehicles/ABCD")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue
        request.httpBody = try! JSONEncoder().encode(body)

        givenService()
        whenGenerateRequestWithBody(endpoint: .vehicleId, method: .POST, body: body, pathKeysValues: ["vehicleId": "ABCD"])
        thenRequestWithBody(is: request)
    }

    func test_Generates_Request_With_Body() {
        let body = "BODY"

        var request = URLRequest(url: URL(string: "https://easyselling.maxencemottard.com/users")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue
        request.httpBody = try! JSONEncoder().encode(body)

        givenService()
        whenGenerateRequestWithBody(endpoint: .users, method: .POST, body: body)
        thenRequestWithBody(is: request)
    }

    func test_Generates_Request_with_filter_query_parameter_equal() {
        var request = URLRequest(url: URL(string: "https://easyselling.maxencemottard.com/items/invoices?filter%5Bvehicle%5D%5B_eq%5D=1")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.GET.rawValue

        givenService()
        whenGenerateRequest(endpoint: .invoices, method: .GET, queryParameters: [FilterQueryParameter(parameterName: "vehicle", type: .EQUAL, value: "1")])
        thenRequest(is: request)
    }

    func test_Generates_Request_with_filter_query_parameter_inn() {
        var request = URLRequest(url: URL(string: "https://easyselling.maxencemottard.com/items/invoices?filter%5Bvehicle%5D%5B_in%5D=1")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.GET.rawValue

        givenService()
        whenGenerateRequest(endpoint: .invoices, method: .GET, queryParameters: [FilterQueryParameter(parameterName: "vehicle", type: .INN, value: "1")])
        thenRequest(is: request)
    }

    func test_Generates_Request_with_filter_query_parameter_between() {
        var request = URLRequest(url: URL(string: "https://easyselling.maxencemottard.com/items/invoices?filter%5Bvehicle%5D%5B_between%5D=1")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.GET.rawValue

        givenService()
        whenGenerateRequest(endpoint: .invoices, method: .GET, queryParameters: [FilterQueryParameter(parameterName: "vehicle", type: .BETWEEN, value: "1")])
        thenRequest(is: request)
    }
    
    func test_JSON_encode_failure() {
        let body = Double.infinity

        givenService()
        whenGenerateRequestWithBody(endpoint: .users, method: .POST, body: body)
        XCTAssertEqual(APICallerError.encodeError, error)
    }

    func test_Deinit_when_no_longer_interested() {
        givenService()
        whenGenerateRequest(endpoint: .users, method: .POST)
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

    private func whenGenerateRequest(endpoint: HTTPEndpoint, method: HTTPMethod,
                                     headers: [String: String] = [:], pathKeysValues: [String: String] = [:], queryParameters: [QueryParameter]? = nil) {
        do {
            self.request = try requestGenerator.generateRequest(endpoint: endpoint, method: method,
                                                                headers: headers, pathKeysValues: pathKeysValues, queryParameters: queryParameters)
        } catch(let error) {
            self.error = (error as! APICallerError)
        }
    }

    private func whenGenerateRequestWithBody<T: Encodable>(
        endpoint: HTTPEndpoint,
        method: HTTPMethod,
        body: T,
        headers: [String: String] = [:],
        pathKeysValues: [String: String] = [:]) {
            do {
                self.request = try requestGenerator.generateRequest(endpoint: endpoint, method: method, body: body,
                                                                    headers: headers, pathKeysValues: pathKeysValues, queryParameters: nil)
            } catch(let error) {
                self.error = (error as! APICallerError)
            }
        }

    private func whenNoLongerInterested() {
        requestGenerator = nil
    }

    private func thenRequest(is expectedRequest: URLRequest, line: UInt = #line) {
        XCTAssertNotNil(request)
        XCTAssertEqual(expectedRequest.url, request.url, line: line)
        XCTAssertEqual(expectedRequest.httpMethod, request.httpMethod, line: line)
        XCTAssertEqual(expectedRequest.allHTTPHeaderFields, request.allHTTPHeaderFields, line: line)
        XCTAssertEqual(expectedRequest.httpBody, request.httpBody, line: line)
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

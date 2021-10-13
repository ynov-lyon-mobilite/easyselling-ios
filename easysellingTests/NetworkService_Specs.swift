//
//  NetworkService_Tests.swift
//  easysellingTests
//
//  Created by Maxence on 11/10/2021.
//

import XCTest
import Combine
@testable import easyselling

class NetworkService_Specs: XCTestCase {
    
    func test_Sends_request_to_back_succeeded_with_codes() {
        assertRequestSucceded(200)
        assertRequestSucceded(201)
        assertRequestSucceded(202)
        assertRequestSucceded(203)
        assertRequestSucceded(204)
        assertRequestSucceded(205)
        assertRequestSucceded(206)
        assertRequestSucceded(207)
        assertRequestSucceded(208)
        assertRequestSucceded(209)
    }
    
    func test_Sends_request_to_back_failed_with_codes() {
        assertRequestFailed(401)
        assertRequestFailed(402)
        assertRequestFailed(403)
        assertRequestFailed(404)
        assertRequestFailed(405)
        assertRequestFailed(406)
        assertRequestFailed(407)
        assertRequestFailed(408)
        assertRequestFailed(409)
        assertRequestFailed(410)

        assertRequestFailed(501)
        assertRequestFailed(502)
        assertRequestFailed(503)
        assertRequestFailed(504)
        assertRequestFailed(505)
        assertRequestFailed(506)
        assertRequestFailed(507)
        assertRequestFailed(508)
        assertRequestFailed(509)
        assertRequestFailed(510)
    }

    func test_Sends_data_to_back_end_with_response_body() {
        let body = "{ \"argument\": \"BODY\"  }"
        let expectedBody = TestDecodable(argument: "BODY")

        givenNetworkService(withReponseHTTPCode: 200, body: body.data(using: .utf8)!)
        whenMakingAPICall(withUrlRequest: request, decodeTo: TestDecodable.self)
        thenAPICallIsSucceding(with: expectedBody)
    }

    private func givenNetworkService(withReponseHTTPCode httpCode: Int, body: Data = Data()) {
        let urlSession = FakeUrlSession(expected: generateExtectedURLResponse(httpCode: httpCode), with: body)
        networkService = NetworkService(urlSession: urlSession)
    }

    private func whenMakingAPICall(withUrlRequest request: URLRequest) {
        let expectation = expectation(description: "Should finish request")
        
        networkService.call(request)
            .sink {
                switch $0 {
                case .failure(let error):
                    expectation.fulfill()
                    self.requestError = error
                case .finished: break
                }
            } receiveValue: {
                expectation.fulfill()
                self.requestResult = $0
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }

    private func whenMakingAPICall<T: Decodable>(withUrlRequest request: URLRequest, decodeTo: T.Type) {
        let expectation = expectation(description: "Should finish request")
        
        networkService.call(request, decodeType: T.self)
            .sink {
                switch $0 {
                case .failure(let error):
                    expectation.fulfill()
                    self.requestError = error
                case .finished: break
                }
            } receiveValue: {
                expectation.fulfill()
                self.requestResult = $0
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 3)
    }

    private func thenResponseErrorCode(is expected: Int) {
        XCTAssertNil(self.requestResult)
        XCTAssertEqual(expected, (self.requestError as NSError?)?.code)
    }

    private func thenAPICallIsSucceding() {
        XCTAssert(self.requestResult is Void)
        XCTAssertNil(self.requestError)
    }

    private func thenAPICallIsSucceding(with expectedBody: TestDecodable) {
        XCTAssertEqual(expectedBody, (self.requestResult as? TestDecodable))
        XCTAssertNil(self.requestError)
    }

    private func generateExtectedURLResponse(httpCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: request.url!, statusCode: httpCode, httpVersion: nil, headerFields: nil)!
    }
    
    private func assertRequestSucceded(_ statusCode: Int) {
        givenNetworkService(withReponseHTTPCode: statusCode)
        whenMakingAPICall(withUrlRequest: request)
        thenAPICallIsSucceding()
    }
    
    private func assertRequestFailed(_ statusCode: Int) {
        givenNetworkService(withReponseHTTPCode: statusCode)
        whenMakingAPICall(withUrlRequest: request)
        thenResponseErrorCode(is: statusCode)
    }

    private var request: URLRequest {
        var request = URLRequest(url: URL(string: "https://easyselling.maxencemottard.com/api/v1/users/profile")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.POST.rawValue

        return request
    }

    private var cancellables = Set<AnyCancellable>()
    private var isCallSucceeded: Bool!
    private var requestResult: Any!
    private var requestError: Error!
    private var networkService: NetworkService!
}

struct TestDecodable: Decodable, Equatable {
    let argument: String
}

class FakeUrlSession: UrlSessionProtocol {
    private let data: Data
    private let response: URLResponse

    init(expected response: URLResponse, with data: Data) {
        self.data = data
        self.response = response
    }

    func dataTaskAnyPublisher(for request: URLRequest) -> AnyPublisherType {
        return Just((data: data, response: response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}

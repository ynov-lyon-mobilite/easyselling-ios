//
//  NetworkService_Tests.swift
//  easysellingTests
//
//  Created by Maxence on 11/10/2021.
//

import XCTest
import Combine
@testable import easyselling

class NetworkService_Tests: XCTestCase {
    
    func test_Sends_data_to_back_end_successfully() {
        givenNetworkService(withReponseHTTPCode: 201)
        whenMakingAPICall(withUrlRequest: request)
        thenAPICallIsSucceding()
    }
    
    func test_Sends_data_to_back_end_error() {
        givenNetworkService(withReponseHTTPCode: 402)
        whenMakingAPICall(withUrlRequest: request)
        thenResponseErrorCode(is: 402)
    }
//
//        resultPublisher.sink {
//            switch $0 {
//            case .failure(_): break
//            case .finished: break
    
    private func givenNetworkService(withReponseHTTPCode httpCode: Int, body: Data = Data()) {
        let urlSession = FakeUrlSession(expected: generateExtectedURLResponse(httpCode: httpCode), with: body)
        networkService = NetworkService(urlSession: urlSession)
    }
    
    private func whenMakingAPICall(withUrlRequest request: URLRequest) {
        networkService.call(request)
            .sink {
                switch $0 {
                case .failure(let error):
                    self.expectation.fulfill()
                    self.requestError = error
                case .finished: break
                }
            } receiveValue: {
                self.expectation.fulfill()
                self.requestResult = $0
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
//            }
//        } receiveValue: { _ in
//            self.isCallSucceeded = true
//        }.store(in: &cancellables)
//
//        XCTAssertTrue(isCallSucceeded)
//    }
    
    private func thenResponseErrorCode(is expected: Int) {
        XCTAssertNil(self.requestResult)
        XCTAssertEqual(expected, (self.requestError as NSError?)?.code)
    }
    
    private func thenAPICallIsSucceding() {
        XCTAssert(self.requestResult is Void)
        XCTAssertNil(self.requestError)
    }
    
//    private let anyPublisher: AnyPublisherType
//
//    init(anyPublisher: AnyPublisherType) {
//        self.anyPublisher = anyPublisher
//    }
    
    private func generateExtectedURLResponse(httpCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: request.url!, statusCode: httpCode, httpVersion: nil, headerFields: nil)!
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
    private lazy var expectation = expectation(description: "Should finish request")
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

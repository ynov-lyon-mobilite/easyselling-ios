//
//  DefaultAccountCreator_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation
import Combine
import XCTest
@testable import easyselling

class DefaultAccountCreator_Specs: XCTestCase {
    
    func test_Creates_account_successfully() {
        let requestGenerator = FakeRequestGenerator()
        let apiCaller = SucceedingAPICaller()
        let accountCreator = DefaultAccountCreator(requestGenerator: requestGenerator, apiCaller: apiCaller)
        
        accountCreator.createAccount(informations: AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "password"))
            .sink {
                switch $0 {
                case .failure(_): break
                case .finished: break
                }
            } receiveValue: {
                self.expectation.fulfill()
                self.isRequestSucceed = true
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 3)

        XCTAssertTrue(isRequestSucceed)
    }
    
//    func test_Creates_account_failed_with_error() {
//        let requestGenerator = FakeRequestGenerator()
//        let apiCaller = SucceedingAPICaller()
//        let accountCreator = DefaultAccountCreator(requestGenerator: requestGenerator, apiCaller: apiCaller)
//        
//        accountCreator.createAccount(informations: AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "password"))
//            .sink {
//                if case let .failure(error) = $0 {
//                    self.expectation.fulfill()
//                    self.error = error
//                }
//            } receiveValue: {
//            }
//            .store(in: &cancellables)
//        wait(for: [expectation], timeout: 3)
//        
//        XCTAssertEqual(404, error.rawValue)
//        XCTAssertEqual("Impossible de trouver ce que vous cherchez", error.errorDescription)
//    }
    
    private var cancellables = Set<AnyCancellable>()
    private lazy var expectation = expectation(description: "Should finish request")
    private var isRequestSucceed: Bool!
    private var error: HTTPError!
}

class FakeRequestGenerator: RequestGenerator {
    
    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod, body: T?, headers: [String : String]) -> URLRequest? {
        return URLRequest(url: URL(string: "https://cuck.com")!)
    }
    
    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String : String]) -> URLRequest? {
        return URLRequest(url: URL(string: "https://cuck.com")!)
    }
}

class SucceedingAPICaller: APICaller {
    private let data: Data?
    
    init(data: Data? = nil) {
        self.data = data
    }
    
    func call<T>(_ urlRequest: URLRequest, decodeType: T.Type) -> DecodedResult<T> where T : Decodable {
        return Just(data!)
            .decode(type: APIResponse<T>.self, decoder: JSONDecoder())
            .map { $0.data }
            .mapError { _ in HTTPError.internalServerError }
            .eraseToAnyPublisher()
    }
    
    func call(_ urlRequest: URLRequest) -> VoidResult {
        return Just(())
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
    }
}

class FailingAPICaller: APICaller {
    
    func call<T>(_ urlRequest: URLRequest, decodeType: T.Type) -> DecodedResult<T> where T : Decodable {
        AnyPublisher(Fail(error: HTTPError.from(statusCode: 404)))
    }
    
    func call(_ urlRequest: URLRequest) -> VoidResult {
        AnyPublisher(Fail(error: HTTPError.from(statusCode: 404)))
    }
}

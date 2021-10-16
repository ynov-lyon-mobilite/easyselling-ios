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
        givenAccountCreator(requestGenerator: FakeRequestGenerator("https://www.google.com"), apiCaller: SucceedingAPICaller())
        whenCreatingAccount()
        thenAccountIsCreated()
    }
    
    func test_Creates_account_failed_with_unfound_ressources() {
        givenAccountCreator(requestGenerator: FakeRequestGenerator("https://www.google.com"), apiCaller: FailingAPICaller(withError: 404))
        whenCreatingAccount()
        thenErrorCode(is: 404)
        thenErrorMessage(is: "Impossible de trouver ce que vous cherchez")
    }
    
    func test_Creates_account_failed_with_wrong_url() {
        givenAccountCreator(requestGenerator: FakeRequestGenerator("google.co"), apiCaller: FailingAPICaller(withError: 400))
        whenCreatingAccount()
        thenErrorCode(is: 400)
        thenErrorMessage(is: "Une erreur est survenue")
    }
    
    func test_Creates_account_failed_with_forbiden_access() {
        givenAccountCreator(requestGenerator: FakeRequestGenerator("google.co"), apiCaller: FailingAPICaller(withError: 404))
        whenCreatingAccount()
        thenErrorCode(is: 404)
        thenErrorMessage(is: "Impossible de trouver ce que vous cherchez")
    }
    
    private func givenAccountCreator(requestGenerator: RequestGenerator, apiCaller: APICaller) {
        accountCreator = DefaultAccountCreator(requestGenerator: requestGenerator, apiCaller: apiCaller)
    }
    
    private func whenCreatingAccount() {
        accountCreator.createAccount(informations: AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "password"))
            .sink {
                if case let .failure(error) = $0 {
                    self.expectation.fulfill()
                    self.error = error
                }
            } receiveValue: {
                self.expectation.fulfill()
                self.isRequestSucceed = true
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 3)
    }
    
    private func thenAccountIsCreated() {
        XCTAssertTrue(isRequestSucceed)
    }
    
    private func thenErrorCode(is expected: Int) {
        XCTAssertEqual(expected, error.rawValue)
    }
    
    private func thenErrorMessage(is expected: String) {
        XCTAssertEqual(expected, error.errorDescription)
    }
    
    private var accountCreator: DefaultAccountCreator!
    private var cancellables = Set<AnyCancellable>()
    private lazy var expectation = expectation(description: "Should finish request")
    private var isRequestSucceed: Bool!
    private var error: HTTPError!
}

class FakeRequestGenerator: RequestGenerator {
    
    init(_ url: String) {
        self.url = url
    }
    
    private var url: String
    
    func generateRequest<T>(endpoint: HTTPEndpoint, method: HTTPMethod, body: T?, headers: [String : String]) -> URLRequest? where T : Encodable {
        return URLRequest(url: URL(string: url)!)
    }
    
    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String : String]) -> URLRequest? {
        return nil
    }
}

class SucceedingAPICaller: APICaller {
    
    func call<T>(_ urlRequest: URLRequest, decodeType: T.Type) -> DecodedResult<T> where T : Decodable {
        return Just("" as! T)
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
    }
    
    func call(_ urlRequest: URLRequest) -> VoidResult {
        return Just(())
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
    }
}

class FailingAPICaller: APICaller {
    
    init(withError error: Int) {
        self.error = error
    }
    
    private var error: Int
    
    func call<T>(_ urlRequest: URLRequest, decodeType: T.Type) -> DecodedResult<T> where T : Decodable {
        AnyPublisher(Fail(error: HTTPError.from(statusCode: error)))
    }
    
    func call(_ urlRequest: URLRequest) -> VoidResult {
        AnyPublisher(Fail(error: HTTPError.from(statusCode: error)))
    }
}

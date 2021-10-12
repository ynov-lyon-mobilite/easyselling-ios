//
//  NetworkService.swift
//  easyselling
//
//  Created by Maxence on 06/10/2021.
//

import Foundation
import Combine

// MARK: Request Execution with Combine
typealias VoidResult = AnyPublisher<Void, Error>
typealias DecodedResult<T: Decodable> = AnyPublisher<T, Error>
typealias BeforeRequestFunction = (() -> VoidResult)?

final class NetworkService {
    private var jsonDecoder = JSONDecoder()
    private var successStatusCodes = Set<Int>(200...209)
    private let urlSession: UrlSessionProtocol

    init(urlSession: UrlSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    //    func call<T: Decodable>(
    //        _ urlRequest: URLRequest,
    //        decodeType: T.Type,
    //        executeBefore: BeforeRequestFunction = nil) -> DecodedResult<T> {
    //        if let executeBefore = executeBefore {
    //            return executeBefore()
    //                .flatMap { _ in
    //                    return call(urlRequest, decodeType: decodeType)
    //                }.eraseToAnyPublisher()
    //        }
    //
    //        return URLSession.shared.dataTaskPublisher(for: urlRequest)
    //            .tryMap { [successStatusCodes] (data, response) -> Data in
    //                if let response = response as? HTTPURLResponse, !successStatusCodes.contains(response.statusCode) {
    //                    throw NSError(domain: "SERVICE_ERROR", code: response.statusCode, userInfo: nil)
    //                }
    //
    //                return data
    //            }
    //            .decode(type: T.self, decoder: jsonDecoder)
    //            .receive(on: DispatchQueue.main)
    //            .eraseToAnyPublisher()
    //    }
    
    func call(_ urlRequest: URLRequest) -> VoidResult {
        return urlSession.dataTaskAnyPublisher(for: urlRequest)
            .tryMap { [successStatusCodes] (_, response) -> Void in
                if let response = response as? HTTPURLResponse, !successStatusCodes.contains(response.statusCode) {
                    throw NSError(domain: "SERVICE_ERROR", code: response.statusCode, userInfo: nil)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension URLSession: UrlSessionProtocol {
    func dataTaskAnyPublisher(for request: URLRequest) -> AnyPublisherType {
        return dataTaskPublisher(for: request)
            .eraseToAnyPublisher()
    }
}

protocol UrlSessionProtocol {
    typealias AnyPublisherType = AnyPublisher<(data: Data, response: URLResponse), URLError>

    func dataTaskAnyPublisher(for request: URLRequest) -> AnyPublisherType
}

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

    func call<T: Decodable>(
        _ urlRequest: URLRequest,
        decodeType: T.Type) -> DecodedResult<T> {
            return urlSession.dataTaskAnyPublisher(for: urlRequest)
                .tryMap { [successStatusCodes] (data, response) -> Data in
                    if let response = response as? HTTPURLResponse, !successStatusCodes.contains(response.statusCode) {
                        throw NSError(domain: "SERVICE_ERROR", code: response.statusCode, userInfo: nil)
                    }

                    return data
                }
                .decode(type: T.self, decoder: jsonDecoder)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }

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

//
//  DefaultAPICaller.swift
//  easyselling
//
//  Created by Maxence on 06/10/2021.
//

import Foundation
import Combine

protocol APICaller {
    func call<T: Decodable>(_ urlRequest: URLRequest, decodeType: T.Type) -> DecodedResult<T>
    func call(_ urlRequest: URLRequest) -> VoidResult
}

final class DefaultAPICaller: APICaller {
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
                        throw HTTPError.from(statusCode: response.statusCode)
                    }

                    return data
                }
                .decode(type: T.self, decoder: jsonDecoder)
                .receive(on: DispatchQueue.main)
                .mapError { ($0 as? HTTPError) ?? HTTPError.internalServerError }
                .eraseToAnyPublisher()
        }

    func call(_ urlRequest: URLRequest) -> VoidResult {
        return urlSession.dataTaskAnyPublisher(for: urlRequest)
            .tryMap { [successStatusCodes] (_, response) -> Void in
                if let response = response as? HTTPURLResponse, !successStatusCodes.contains(response.statusCode) {
                    throw HTTPError.from(statusCode: response.statusCode)
                }
            }
            .receive(on: DispatchQueue.main)
            .mapError { ($0 as? HTTPError) ?? HTTPError.internalServerError }
            .eraseToAnyPublisher()
    }
}

//
//  NetworkService.swift
//  easyselling
//
//  Created by Maxence on 06/10/2021.
//

import Foundation
import Combine

//  MARK: Request Execution with Combine
typealias VoidResult = AnyPublisher<Void, Error>
typealias DecodedResult<T: Decodable> = AnyPublisher<T, Error>
typealias BeforeRequestFunction = (() -> VoidResult)?

final class NetworkService {
    private let baseUrl: String
    private var jsonDecoder = JSONDecoder()
    private var jsonEncoder = JSONEncoder()
    
    private var successStatusCodes = Set<Int>(200...209)
    private var fixHeaders: [String: String] = ["Content-Type": "application/json"]

    init(baseUrl: String) {
        self.baseUrl = baseUrl
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
//
//    func call(_ urlRequest: URLRequest, executeBefore: BeforeRequestFunction = nil) -> VoidResult {
//        if let executeBefore = executeBefore {
//            return executeBefore()
//                .flatMap { _ in
//                    return call(urlRequest)
//                }.eraseToAnyPublisher()
//        }
//
//        return URLSession.shared.dataTaskPublisher(for: urlRequest)
//            .tryMap { [successStatusCodes] (data, response) -> Void in
//                if let response = response as? HTTPURLResponse, !successStatusCodes.contains(response.statusCode) {
//                    throw NSError(domain: "SERVICE_ERROR", code: response.statusCode, userInfo: nil)
//                }
//            }
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
    
    //  MARK: URLRequest Generation
    func generateRequest<T: Encodable>(endpoint: String, method: HTTPMethod = .GET,
                                       body: T, headers: [String: String] = [:]) -> URLRequest? {
        guard var request = generateRequest(from: endpoint, method: method, headers: headers),
              let encodedBody = try? jsonEncoder.encode(body) else {
            return nil
        }
        
        request.httpBody = encodedBody
        
        return request
    }
    
    func generateRequest(
        withoutBody endpoint: String,
        method: HTTPMethod = .GET,
        headers: [String: String] = [:]) -> URLRequest? {
        return generateRequest(from: endpoint, method: method, headers: headers)
    }
    
    private func generateRequest(from endpoint: String, method: HTTPMethod, headers: [String: String]) -> URLRequest? {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        fixHeaders
            .merging(headers) { _, dynamic in
                return dynamic
            }.forEach {
                request.addValue($1, forHTTPHeaderField: $0)
            }
        
        return request
    }
}

//
//  DefaultAPICaller.swift
//  easyselling
//
//  Created by Maxence on 06/10/2021.
//

import Foundation
import Combine

protocol APICaller {
    func call<T: Decodable>(_ urlRequest: URLRequest, decodeType: T.Type) async throws -> T
    func call(_ urlRequest: URLRequest) async throws
}

final class DefaultAPICaller: APICaller {
    private var jsonDecoder = JSONDecoder()
    private var successStatusCodes = Set<Int>(200...209)
    private let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func call<T: Decodable>(
        _ urlRequest: URLRequest,
        decodeType: T.Type) async throws -> T {
            let result: (Data, URLResponse)? = try? await urlSession.data(for: urlRequest, delegate: nil)
            
            guard let (data, response) = result,
                  let strongResponse = response as? HTTPURLResponse else {
                      throw HTTPError.internalServerError
                  }
            
            if !successStatusCodes.contains(strongResponse.statusCode) {
                throw HTTPError.from(statusCode: strongResponse.statusCode)
            }
            
            guard let decodedResult = try? jsonDecoder.decode(T.self, from: data) else {
                throw HTTPError.decodeError
            }
            
            return decodedResult
        }

    func call(_ urlRequest: URLRequest) async throws {
        let result: (Data, URLResponse)? = try? await urlSession.data(for: urlRequest, delegate: nil)
        
        guard let (_, response) = result,
              let strongResponse = response as? HTTPURLResponse else {
                  throw HTTPError.internalServerError
              }
        
        if !successStatusCodes.contains(strongResponse.statusCode) {
            throw HTTPError.from(statusCode: strongResponse.statusCode)
        }
    }
}

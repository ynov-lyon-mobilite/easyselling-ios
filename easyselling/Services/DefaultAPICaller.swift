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
                      throw APICallerError.internalServerError
                  }

            if !successStatusCodes.contains(strongResponse.statusCode) {
                throw APICallerError.from(statusCode: strongResponse.statusCode)
            }

            do {
                let decodedResult = try jsonDecoder.decode(APIResponse<T>.self, from: data)
                return decodedResult.data
            } catch (let error) {
                print(error)
                throw APICallerError.decodeError
            }
        }

    func call(_ urlRequest: URLRequest) async throws {
        let result: (Data, URLResponse)? = try? await urlSession.data(for: urlRequest, delegate: nil)

        guard let (_, response) = result,
              let strongResponse = response as? HTTPURLResponse else {
                  throw APICallerError.internalServerError
              }

        if !successStatusCodes.contains(strongResponse.statusCode) {
            throw APICallerError.from(statusCode: strongResponse.statusCode)
        }
    }
}

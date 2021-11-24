//
//  DefaultAutorizedRequestGenerator.swift
//  easyselling
//
//  Created by Maxence on 02/11/2021.
//

import Foundation

protocol AuthorizedRequestGenerator {
    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String: String],
                         pathKeysValues: [String: String]) async throws -> URLRequest
    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod, body: T?, headers: [String: String],
                                       pathKeysValues: [String: String]) async throws -> URLRequest
}

class DefaultAuthorizedRequestGenerator: AuthorizedRequestGenerator {
    private let requestGenerator: RequestGenerator
    private var tokenManager: TokenManager
    private let tokenRefreshor: TokenRefreshor

    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(),
         tokenManager: TokenManager = DefaultTokenManager.shared,
         tokenRefreshor: TokenRefreshor = DefaultTokenRefreshor()) {
        self.requestGenerator = requestGenerator
        self.tokenManager = tokenManager
        self.tokenRefreshor = tokenRefreshor
    }

    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String : String],
                         pathKeysValues: [String: String]) async throws -> URLRequest {
        var request = try requestGenerator.generateRequest(endpoint: endpoint, method: method,
                                                           headers: headers, pathKeysValues: pathKeysValues)

        let token = try await refreshToken()
        request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")

        return request
    }

    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod, body: T?,
                                       headers: [String : String], pathKeysValues: [String: String]) async throws -> URLRequest {
        var request = try requestGenerator.generateRequest(endpoint: endpoint, method: method, body: body,
                                                           headers: headers, pathKeysValues: pathKeysValues)

        let token = try await refreshToken()
        request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")

        return request
    }

    private func refreshToken() async throws -> String {
        guard let token = tokenManager.accessToken,
              let refreshToken = tokenManager.refreshToken else {
                  throw APICallerError.unauthorized
              }

        if !tokenManager.accessTokenIsExpired {
            return token
        }

        let tokenResult = try await tokenRefreshor.refresh(refreshToken: refreshToken)
        tokenManager.accessToken = tokenResult.accessToken
        tokenManager.refreshToken = tokenResult.refreshToken

        return tokenResult.accessToken
    }
}

//
//  DefaultAutorizedRequestGenerator.swift
//  easyselling
//
//  Created by Maxence on 02/11/2021.
//

import Foundation

protocol AuthorizedRequestGenerator {
    func generateRequest(
        endpoint: HTTPEndpoint,
        method: HTTPMethod,
        headers: [String: String],
        pathKeysValues: [String: String],
        queryParameters: [String: String]?
    ) async throws -> URLRequest

    func generateRequest<T: Encodable>(
        endpoint: HTTPEndpoint,
        method: HTTPMethod,
        body: T?, headers: [String: String],
        pathKeysValues: [String: String],
        queryParameters: [String: String]?
    ) async throws -> URLRequest
}

class DefaultAuthorizedRequestGenerator: AuthorizedRequestGenerator {
    private let requestGenerator: RequestGenerator
    private let firebaseAuthProvider: FirebaseAuthProvider

    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(),
         firebaseAuthProvider: FirebaseAuthProvider = DefaultFirebaseAuthProvider()) {
        self.requestGenerator = requestGenerator
        self.firebaseAuthProvider = firebaseAuthProvider
    }

    func generateRequest(endpoint: HTTPEndpoint, method: HTTPMethod, headers: [String : String],
                         pathKeysValues: [String: String], queryParameters: [String: String]?) async throws -> URLRequest {
        var request = try requestGenerator.generateRequest(
            endpoint: endpoint, method: method, headers: headers,
            pathKeysValues: pathKeysValues, queryParameters: queryParameters)

        let token = try await getToken()
        request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")

        return request
    }

    func generateRequest<T: Encodable>(endpoint: HTTPEndpoint, method: HTTPMethod, body: T?,
                                       headers: [String : String], pathKeysValues: [String: String],
                                       queryParameters: [String: String]?) async throws -> URLRequest {
        var request = try requestGenerator.generateRequest(
            endpoint: endpoint, method: method, body: body, headers: headers,
            pathKeysValues: pathKeysValues, queryParameters: queryParameters)

        let token = try await getToken()
        request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")

        return request
    }

    private func getToken() async throws -> String {
        guard let token = await firebaseAuthProvider.getAccessToken() else {
            throw APICallerError.unauthorized
        }

        return token
    }
}

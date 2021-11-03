//
//  DefaultTokenRefreshor.swift
//  easyselling
//
//  Created by Maxence on 02/11/2021.
//

import Foundation

protocol TokenRefreshor {
    func refresh(refreshToken: String) async throws -> Token
}

final class DefaultTokenRefreshor: TokenRefreshor {
    private var requestGenerator: RequestGenerator
    private var apiCaller: APICaller
    
    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(), urlSession: URLSessionProtocol = URLSession.shared) {
        self.requestGenerator = requestGenerator
        self.apiCaller = DefaultAPICaller(urlSession: urlSession)
    }
    
    func refresh(refreshToken: String) async throws -> Token {
        let dto = RefreshDTO(refreshToken: refreshToken)
        let request = try requestGenerator.generateRequest(endpoint: .authRefresh, method: .POST, body: dto, headers: [:])
        return try await apiCaller.call(request, decodeType: Token.self)
    }
}

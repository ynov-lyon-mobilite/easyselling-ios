//
//  DefaultUserAuthenticator.swift
//  easyselling
//
//  Created by Maxence on 19/10/2021.
//

import Foundation

protocol UserAuthenticatior {
    func login(mail: String, password: String) async throws -> Token
}

final class DefaultUserAuthenticator: UserAuthenticatior {
    private var requestGenerator: RequestGenerator
    private var apiCaller: APICaller
    
    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(), urlSession: URLSessionProtocol = URLSession.shared) {
        self.requestGenerator = requestGenerator
        self.apiCaller = DefaultAPICaller(urlSession: urlSession)
    }
    
    func login(mail: String, password: String) async throws -> Token {
        let dto = LoginDTO(email: mail, password: password)
        let urlRequest = try requestGenerator.generateRequest(endpoint: .authLogin, method: .POST, body: dto, headers: [:])
        return try await apiCaller.call(urlRequest, decodeType: Token.self)
    }
}

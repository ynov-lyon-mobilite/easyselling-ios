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

    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    func login(mail: String, password: String) async throws -> Token {
        let dto = LoginDTO(email: mail, password: password)
        let urlRequest = try requestGenerator.generateRequest(endpoint: .authLogin, method: .POST, body: dto,
                                                              headers: [:], pathKeysValues: [:], queryParameters: nil)
        return try await apiCaller.call(urlRequest, decodeType: Token.self)
    }
}

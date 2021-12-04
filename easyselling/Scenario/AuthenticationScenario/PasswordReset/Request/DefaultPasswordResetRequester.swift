//
//  DefaultPasswordResetRequester.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 07/11/2021.
//

import Foundation

protocol PasswordResetRequester {
    func askForPasswordReset(of email: String) async throws
}

class DefaultPasswordResetRequester: PasswordResetRequester {

    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    private var requestGenerator: RequestGenerator
    private var apiCaller: APICaller

    func askForPasswordReset(of email: String) async throws {
        let urlRequest = try requestGenerator
            .generateRequest(endpoint: .passwordResetRequest, method: .POST, body: EmailDTO(email: email),
                             headers: [:], pathKeysValues: [:], queryParameters: nil)
        try await apiCaller.call(urlRequest)
    }
}

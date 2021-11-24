//
//  DefaultPasswordReseter.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 12/11/2021.
//

import Foundation

protocol PasswordReseter {
    func resetPassword(with passwordResetInformations: PasswordResetDTO) async throws
}

class DefaultPasswordReseter: PasswordReseter {

    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(),
         apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    private var requestGenerator: RequestGenerator
    private var apiCaller: APICaller

    func resetPassword(with passwordResetInformations: PasswordResetDTO) async throws {
        let request = try requestGenerator.generateRequest(endpoint: .passwordReset, method: .POST, body: passwordResetInformations)
        try await apiCaller.call(request)
    }
}

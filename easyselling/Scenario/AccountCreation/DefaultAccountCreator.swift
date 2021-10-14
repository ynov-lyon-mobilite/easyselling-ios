//
//  DefaultAccountCreator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/10/2021.
//

import Foundation
import Combine

protocol AccountCreator {
    func createAccount(informations: AccountCreationInformations) -> VoidResult
}

class DefaultAccountCreator: AccountCreator {
    
    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }
    
    private var requestGenerator: RequestGenerator
    private var apiCaller: APICaller
    
    func createAccount(informations: AccountCreationInformations) -> VoidResult {
        let urlRequest = requestGenerator.generateRequest(endpoint: .users, method: .POST, body: informations, headers: [:])
        guard let urlRequest = urlRequest else {
            return AnyPublisher(Empty())
        }
        return apiCaller.call(urlRequest)
    }
}

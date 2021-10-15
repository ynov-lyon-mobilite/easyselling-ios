//
//  DefaultUserAuthenticator.swift
//  easyselling
//
//  Created by Maxence on 15/10/2021.
//

import Foundation

protocol UserAuthenticator {
    func login(mail: String, password: String, otp: String?) -> DecodedResult<TokenResponse>
}

class DefaultUserAuthenticator: UserAuthenticator {
    private var requestGenerator: RequestGenerator
    private var apiCaller: APICaller
    
    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }
    
    func login(mail: String, password: String, otp: String?) -> DecodedResult<TokenResponse> {
        let body = LoginInformations(email: mail, password: password, otp: otp)
        let urlRequest = requestGenerator.generateRequest(endpoint: .usersLogin, method: .POST, body: body, headers: [:])
        guard let urlRequest = urlRequest else { return .empty }
        
        return apiCaller.call(urlRequest, decodeType: TokenResponse.self)
    }
}

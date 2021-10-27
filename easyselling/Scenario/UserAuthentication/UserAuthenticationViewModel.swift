//
//  UserAuthenticationViewModel.swift
//  easyselling
//
//  Created by Maxence on 20/10/2021.
//

import Foundation

final class UserAuthenticationViewModel: ObservableObject {
    private let tokenManager: TokenManager
    private let userAuthenticator: UserAuthenticatior
//    @Published var token: Token?
    @Published var error: APICallerError?
    
    init(userAuthenticator: UserAuthenticatior = DefaultUserAuthenticator(), tokenManager: TokenManager = .shared) {
        self.userAuthenticator = userAuthenticator
        self.tokenManager = tokenManager
    }
    
    func login(mail: String, password: String) async {
        do {
            let token = try await userAuthenticator.login(mail: mail, password: password)
            tokenManager.accessToken = token.accessToken
            tokenManager.refreshToken = token.refreshToken
        } catch(let error) {
            self.error = (error as? APICallerError)
        }
    }
}

//
//  UserAuthenticationViewModel.swift
//  easyselling
//
//  Created by Maxence on 20/10/2021.
//

import Foundation

final class UserAuthenticationViewModel: ObservableObject {
    private let userAuthenticator: UserAuthenticatior
    @Published var token: Token?
    @Published var error: APICallerError?
    
    init(userAuthenticator: UserAuthenticatior = DefaultUserAuthenticator()) {
        self.userAuthenticator = userAuthenticator
    }
    
    func login(mail: String, password: String) async {
        do {
            token = try await userAuthenticator.login(mail: mail, password: password)
        } catch(let error) {
            self.error = (error as? APICallerError)
        }
    }
}

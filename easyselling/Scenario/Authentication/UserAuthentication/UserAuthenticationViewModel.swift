//
//  UserAuthenticationViewModel.swift
//  easyselling
//
//  Created by Maxence on 20/10/2021.
//

import Foundation

final class UserAuthenticationViewModel: ObservableObject {
    private var tokenManager: TokenManager
    private let userAuthenticator: UserAuthenticatior
    
    let navigateToAccountCreation: Action

    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var hasError = false
    @Published var error: ViewModelError? {
        didSet {
            hasError = (error != nil)
        }
    }
    
    init(navigateToAccountCreation: @escaping Action, userAuthenticator: UserAuthenticatior = DefaultUserAuthenticator(), tokenManager: TokenManager = DefaultTokenManager.shared) {
        self.userAuthenticator = userAuthenticator
        self.tokenManager = tokenManager
        self.navigateToAccountCreation = navigateToAccountCreation
    }
    
    func verifyInformations() throws {
        if email.isEmpty { throw ViewModelError.emptyEmail }
        if password.isEmpty { throw ViewModelError.emptyPassword }
    }
    
    @MainActor func login() async {
        do {
            try verifyInformations()
            let token = try await userAuthenticator.login(mail: email, password: password)
            tokenManager.accessToken = token.accessToken
            tokenManager.refreshToken = token.refreshToken
        } catch(let error) {
            if let error = error as? ViewModelError {
                self.error = error
            } else if (error as? APICallerError) == .unauthorized {
                self.error = .badCredentials
            } else {
                self.error = .unknow
            }
        }
    }
    
    enum ViewModelError: LocalizedError, Equatable {
        case emptyEmail
        case emptyPassword
        case badCredentials
        case unknow
        
        var isAlertError: Bool { [.badCredentials, .unknow].contains(self) }

        var errorDescription: String? {
            switch self {
            case .emptyEmail: return "L'addresse email est vide"
            case .emptyPassword: return "Le mot de passe est vide"
            case .badCredentials: return "Le couple identifiant/mot de passe est incorrect. Veuillez réessayer."
            case .unknow: return "Une erreur est survenue"
            }
        }
    }
}

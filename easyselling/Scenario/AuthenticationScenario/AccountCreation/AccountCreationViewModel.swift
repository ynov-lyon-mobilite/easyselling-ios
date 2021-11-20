//
//  AccountCreationViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation
import Combine

class AccountCreationViewModel: ObservableObject {
    
    init(preparator: CredentialsPreparator = DefaultCredentialsPreparator(), accountCreator: AccountCreator = DefaultAccountCreator(), onAccountCreated: @escaping Action) {
        self.preparator = preparator
        self.accountCreator = accountCreator
        self.onAccountCreated = onAccountCreated
    }
    
    private var preparator: CredentialsPreparator
    private var accountCreator: AccountCreator
    private let onAccountCreated: Action
    
    @Published var state: AccountCreationState = .initial
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    @Published var error: CredentialsError?
    @Published var alert: APICallerError?
    @Published var showAlert: Bool = false
    
    func createAccount() async {
        self.state = .loading
        do {
            let informations = try preparator.prepare(email: email, password: password, passwordConfirmation: passwordConfirmation)
            await self.createAccount(with: informations)
        } catch(let error) {
            self.state = .initial
            self.setError(with: (error as? CredentialsError) ?? .unknow)
        }
    }
    
    @MainActor private func createAccount(with informations: AccountCreationInformations) async {
        do {
            try await accountCreator.createAccount(informations: informations)
            self.state = .accountCreated
            self.onAccountCreated()
        } catch(let error) {
            self.state = .initial
            self.alert = (error as? APICallerError) ?? APICallerError.internalServerError
            self.showAlert = true
        }
    }
    
    private func setError(with error: CredentialsError) {
        self.error = error
    }
    
    enum AccountCreationState: Equatable {
        case initial
        case loading
        case accountCreated
    }
}

protocol CredentialsTransformator {
    func transform(email: String, password: String, passwordConfirmation: String) -> AccountCreationInformations
}

class DefaultCredentialsTransformator: CredentialsTransformator {
    
    func transform(email: String, password: String, passwordConfirmation: String) -> AccountCreationInformations {
        AccountCreationInformations(email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
}

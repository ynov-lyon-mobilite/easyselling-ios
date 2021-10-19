//
//  AccountCreationViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation
import Combine

class AccountCreationViewModel: ObservableObject {
    
    init(verificator: InformationsVerificator, accountCreator: AccountCreator = DefaultAccountCreator()) {
        self.verificator = verificator
        self.accountCreator = accountCreator
    }
    
    private var verificator: InformationsVerificator
    private var accountCreator: AccountCreator
    
    @Published var state: AccountCreationState = .initial
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    @Published var error: AccountCreationError?
    @Published var alert: APICallerError?
    @Published var showAlert: Bool = false
    
    func createAccount(email: String, password: String, passwordConfirmation: String) async {
        self.state = .loading
        do {
            let informationsVerified = try verificator.verify(email: email, password: password, passwordConfirmation: passwordConfirmation)
            await self.createAccount(with: informationsVerified)
        } catch(let error) {
            self.state = .initial
            self.setError(with: (error as? AccountCreationError) ?? .unknow)
        }
    }
    
    private func createAccount(with informations: AccountCreationInformations) async {
        do {
            try await accountCreator.createAccount(informations: informations)
            self.state = .accountCreated
        } catch(let error) {
            self.state = .initial
            self.alert = (error as? APICallerError) ?? APICallerError.internalServerError
            self.showAlert = true
        }
    }
    
    private func setError(with error: AccountCreationError) {
        self.error = error
    }
    
    enum AccountCreationState: Equatable {
        case initial
        case loading
        case accountCreated
    }
}

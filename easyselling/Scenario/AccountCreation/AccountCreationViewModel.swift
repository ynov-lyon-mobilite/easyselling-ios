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
    private var cancellables = Set<AnyCancellable>()
    
    @Published var state: AccountCreationState = .initial
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    @Published var error: AccountCreationError?
    
    func verifyInformations(email: String, password: String, passwordConfirmation: String) {
        verificator.verify(email: email, password: password, passwordConfirmation: passwordConfirmation, onVerified: {
            switch $0 {
            case .success: self.state = .loading
            case let .failure(error): self.setError(with: error)
            }
        })
    }
    
    func createAccount(with informations: AccountCreationInformations , onFinish: @escaping (Result<Void, Error>) -> Void) {
        accountCreator.createAccount(informations: informations).sink(receiveCompletion: {
            if case let .failure(error) = $0 {
                onFinish(.failure(error))
            }
        }, receiveValue: {
            onFinish(.success(()))
        })
            .store(in: &cancellables)
    }
    
    private func setError(with error: AccountCreationError) {
        self.error = error
        self.state = .initial
    }
    
    enum AccountCreationState: Equatable {
        case initial
        case loading
    }
}

//
//  AccountCreationViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation

class AccountCreationViewModel: ObservableObject {
    
    init(verificator: InformationsVerificator) {
        self.verificator = verificator
    }
    
    private var verificator: InformationsVerificator
    
    @Published var state: AccountCreationState = .initial
    
    func verifyInformations(email: String, password: String, passwordConfirmation: String) {
        let accountInformations = AccountCreationInformations(email: email, password: password, passwordConfirmation: passwordConfirmation)
        verificator.verify(accountInformations, onVerified: {
            switch $0 {
            case .success: self.state = .loading
            case let .failure(error): self.setError(with: error)
            }
        })
    }
    
    private func setError(with error: AccountCreationError) {
        guard let errorDescription = error.errorDescription else { return }
        self.state = .alert(errorMessage: errorDescription)
    }
    
    enum AccountCreationState: Equatable {
        case initial
        case loading
        case alert(errorMessage: String)
    }
}

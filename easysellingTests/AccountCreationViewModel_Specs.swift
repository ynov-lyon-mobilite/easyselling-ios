//
//  AccountCreationViewModel.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation
import XCTest
@testable import easyselling

class AccountCreationViewModel_Specs: XCTestCase {
    
    func test_Shows_informations_inputs_when_arriving_on_account_creation_page() {
        let informationsVerificator = SucceedingInformationsVerificator()
        let viewModel = AccountCreationViewModel(verificator: informationsVerificator)
        XCTAssertEqual(.initial, viewModel.state)
    }

    func test_Shows_loader_when_informations_are_correct() {
        let informationsVerificator = SucceedingInformationsVerificator()
        let viewModel = AccountCreationViewModel(verificator: informationsVerificator)
        viewModel.verifyInformations(email: "test@test.com",
                                     password: "password",
                                     passwordConfirmation: "password")
        XCTAssertEqual(.loading, viewModel.state)
    }
    
    func test_Show_alert_when_informations_email_is_wrong() {
        let informationsVerificator = FailingInformationsVerificator(error: .wrongEmail)
        let viewModel = AccountCreationViewModel(verificator: informationsVerificator)
        viewModel.verifyInformations(email: "test",
                                     password: "password",
                                     passwordConfirmation: "password")
        XCTAssertEqual(.alert(errorMessage: "L'addresse email est incorrect"), viewModel.state)
    }
    
    func test_Show_alert_when_informations_email_is_empty() {
        let informationsVerificator = FailingInformationsVerificator(error: .wrongEmail)
        let viewModel = AccountCreationViewModel(verificator: informationsVerificator)
        viewModel.verifyInformations(email: "",
                                     password: "password",
                                     passwordConfirmation: "password")
        XCTAssertEqual(.alert(errorMessage: "L'addresse email est incorrect"), viewModel.state)
    }
    
    func test_Show_alert_when_informations_password_is_incorrect() {
        let informationsVerificator = FailingInformationsVerificator(error: .wrongPassword)
        let viewModel = AccountCreationViewModel(verificator: informationsVerificator)
        viewModel.verifyInformations(email: "test@test.com",
                                     password: "password",
                                     passwordConfirmation: "differentPassword")
        XCTAssertEqual(.alert(errorMessage: "Les mots de passes sont différents"), viewModel.state)
    }
    
    func test_Show_alert_when_informations_password_is_empty() {
        let informationsVerificator = FailingInformationsVerificator(error: .emptyPassword)
        let viewModel = AccountCreationViewModel(verificator: informationsVerificator)
        viewModel.verifyInformations(email: "test@test.com",
                                     password: "",
                                     passwordConfirmation: "password")
        XCTAssertEqual(.alert(errorMessage: "Le mot de passe est vide"), viewModel.state)
    }
    
    func test_Show_alert_when_informations_password_confirmation_is_empty() {
        let informationsVerificator = FailingInformationsVerificator(error: .emptyPasswordConfirmation)
        let viewModel = AccountCreationViewModel(verificator: informationsVerificator)
        viewModel.verifyInformations(email: "test@test.com",
                                     password: "password",
                                     passwordConfirmation: "")
        XCTAssertEqual(.alert(errorMessage: "La confirmation du mot de passe est vide"), viewModel.state)
    }
}

class SucceedingInformationsVerificator: InformationsVerificator {
    
    func verify(_ informations: AccountCreationInformations, onVerified: @escaping (Result<Void, AccountCreationError>) -> Void) {
        onVerified(.success(()))
    }
}

class FailingInformationsVerificator: InformationsVerificator {
    
    init(error: AccountCreationError) {
        self.error = error
    }
    
    private var error: AccountCreationError
    
    func verify(_ informations: AccountCreationInformations, onVerified: @escaping (Result<Void, AccountCreationError>) -> Void) {
        onVerified(.failure(error))
    }
}

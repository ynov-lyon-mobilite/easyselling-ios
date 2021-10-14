//
//  AccountCreationViewModel.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation
import Combine
import XCTest
@testable import easyselling

class AccountCreationViewModel_Specs: XCTestCase {
    
    func test_Shows_loader_when_informations_are_correct() {
        verifiedInformations = AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "password")
        
        givenViewModel(with: SucceedingInformationsVerificator(informations: verifiedInformations))
        whenVerifyingInformations(email: "test@test.com", password: "password", passwordConfirmation: "password")
        thenViewModelState(is: .loading)
    }

    func test_Show_alert_when_informations_email_is_wrong() {
        givenViewModel(with: FailingInformationsVerificator(error: .wrongEmail))
        whenVerifyingInformations(email: "test", password: "password", passwordConfirmation: "password")
        thenViewModelState(is: .initial)
        thenError(is: .wrongEmail)
    }

    func test_Show_alert_when_informations_email_is_empty() {
        givenViewModel(with: FailingInformationsVerificator(error: .emptyEmail))
        whenVerifyingInformations(email: "", password: "password", passwordConfirmation: "password")
        thenViewModelState(is: .initial)
        thenError(is: .emptyEmail)
    }

    func test_Show_alert_when_informations_password_is_incorrect() {
        givenViewModel(with: FailingInformationsVerificator(error: .wrongPassword))
        whenVerifyingInformations(email: "test", password: "password", passwordConfirmation: "differentPassword")
        thenViewModelState(is: .initial)
        thenError(is: .wrongPassword)
    }

    func test_Show_alert_when_informations_password_is_empty() {
        givenViewModel(with: FailingInformationsVerificator(error: .emptyPassword))
        whenVerifyingInformations(email: "test", password: "", passwordConfirmation: "password")
        thenViewModelState(is: .initial)
        thenError(is: .emptyPassword)
    }

    func test_Show_alert_when_informations_password_confirmation_is_empty() {
        givenViewModel(with: FailingInformationsVerificator(error: .emptyPasswordConfirmation))
        whenVerifyingInformations(email: "test", password: "password", passwordConfirmation: "")
        thenViewModelState(is: .initial)
        thenError(is: .emptyPasswordConfirmation)
    }

    func test_Deinits_when_no_longer_interest() {
        verifiedInformations = AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "password")
        
        givenViewModel(with: SucceedingInformationsVerificator(informations: verifiedInformations))
        whenVerifyingInformations(email: "test@test.com", password: "password", passwordConfirmation: "passwordConfirmation")
        whenNoLongerInterested()
        XCTAssertNil(viewModel)
    }

    func test_Sends_informations_when_asking_for_account_creation() {
        verifiedInformations = AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "password")

        givenViewModel(with: SucceedingInformationsVerificator(informations: verifiedInformations))
        whenVerifyingInformations(email: "test@test.com", password: "password", passwordConfirmation: "password")
        whenCreatingAccount()
        thenAccountIsCreated()
    }
    
    private func givenViewModel(with verificator: InformationsVerificator) {
        let accountCreator = SuccedingAccountCreator()
        viewModel = AccountCreationViewModel(verificator: verificator, accountCreator: accountCreator)
    }
    
    private func whenVerifyingInformations(email: String, password: String, passwordConfirmation: String) {
        viewModel.verifyInformations(email: email,
                                     password: password,
                                     passwordConfirmation: passwordConfirmation)
    }

    private func whenCreatingAccount() {
        whenVerifyingInformations(email: verifiedInformations.email, password: verifiedInformations.password, passwordConfirmation: verifiedInformations.passwordConfirmation)
        viewModel.createAccount(with: verifiedInformations, onFinish: {
            switch $0 {
            case .success: self.accountCreated = true
            case .failure(_): break
            }
        })
    }
    
    private func whenNoLongerInterested() {
        viewModel = nil
    }
    
    private func thenViewModelState(is expected: AccountCreationViewModel.AccountCreationState) {
        XCTAssertEqual(expected, viewModel.state)
    }
    
    private func thenError(is expected: AccountCreationError) {
        XCTAssertEqual(expected, viewModel.error)
    }
    
    private func thenAccountIsCreated() {
        XCTAssertTrue(accountCreated)
    }
    
    private var viewModel: AccountCreationViewModel!
    private var accountCreated: Bool!
    private var verifiedInformations: AccountCreationInformations!
}

class SuccedingAccountCreator: AccountCreator {
    
    func createAccount(informations: AccountCreationInformations) -> VoidResult {
        return Just(())
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
    }
}

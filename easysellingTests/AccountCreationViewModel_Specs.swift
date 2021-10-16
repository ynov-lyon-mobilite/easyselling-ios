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

    func test_Sends_back_account_informations_when_asking_for_account_creation() {
        givenViewModel(verificator: SucceedingInformationsVerificator())
        whenCreatingAccount(email: "test@test.com", password: "password", passwordConfirmation: "password")
        thenVerifiedInformations(are: AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "password"))
    }
    
    func test_Sends_back_account_informations_when_asking_for_account_creation2() {
        givenViewModel(verificator: SucceedingInformationsVerificator())
        thenViewModelState(is: .initial)
        whenCreatingAccount(email: "test@test.com", password: "password", passwordConfirmation: "password")
        thenVerifiedInformations(are: AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "password"))
        thenViewModelState(is: .accountCreated)
    }
    
    func test_Shows_loader_when_informations_are_being_compute() {
        givenViewModel(with: NeverFinishingInformationsVerificator())
        whenCreatingAccount(email: "test@test.com", password: "password", passwordConfirmation: "password")
        thenViewModelState(is: .loading)
    }
    
    func test_Show_error_when_informations_email_is_wrong() {
        givenViewModel(with: FailingInformationsVerificator(error: .wrongEmail))
        whenCreatingAccount(email: "test", password: "password", passwordConfirmation: "password")
        thenViewModelState(is: .initial)
        thenError(is: .wrongEmail)
    }
    
    
    func test_Show_error_when_informations_email_is_empty() {
        givenViewModel(with: FailingInformationsVerificator(error: .emptyEmail))
        whenCreatingAccount(email: "", password: "password", passwordConfirmation: "password")
        thenViewModelState(is: .initial)
        thenError(is: .emptyEmail)
    }

    func test_Show_error_when_informations_password_is_incorrect() {
        givenViewModel(with: FailingInformationsVerificator(error: .wrongPassword))
        whenCreatingAccount(email: "test", password: "password", passwordConfirmation: "differentPassword")
        thenViewModelState(is: .initial)
        thenError(is: .wrongPassword)
    }

    func test_Show_error_when_informations_password_is_empty() {
        givenViewModel(with: FailingInformationsVerificator(error: .emptyPassword))
        whenCreatingAccount(email: "test", password: "", passwordConfirmation: "password")
        thenViewModelState(is: .initial)
        thenError(is: .emptyPassword)
    }

    func test_Show_error_when_informations_password_confirmation_is_empty() {
        givenViewModel(with: FailingInformationsVerificator(error: .emptyPasswordConfirmation))
        whenCreatingAccount(email: "test", password: "password", passwordConfirmation: "")
        thenViewModelState(is: .initial)
        thenError(is: .emptyPasswordConfirmation)
    }
    
    func test_Shows_alert_when_an_error_occured_with_request() {
        givenViewModel(verificator: SucceedingInformationsVerificator(), accountCreator: FailingAccountCreator(error: .forbidden))
        whenCreatingAccount(email: "test", password: "password", passwordConfirmation: "password")
        thenViewModelState(is: .initial)
        thenAlert(is: .forbidden)
        XCTAssertTrue(viewModel.showAlert)
    }
    
    private func thenAlert(is expected: HTTPError) {
        XCTAssertEqual(expected, viewModel.alert)
    }

    func test_Deinits_when_no_longer_interest() {
        givenViewModel(with: SucceedingInformationsVerificator())
        whenCreatingAccount(email: "test@test.com", password: "password", passwordConfirmation: "password")
        whenNoLongerInterested()
        XCTAssertNil(viewModel)
    }
    
    private func givenViewModel(verificator: SucceedingInformationsVerificator, accountCreator: AccountCreator = SucceedingAccountCreator()) {
        self.succeedingVerificator = verificator
        viewModel = AccountCreationViewModel(verificator: verificator, accountCreator: accountCreator)
    }
    
    private func givenViewModel(with verificator: NeverFinishingInformationsVerificator) {
        self.neverFinishingVerificator = verificator
        let accountCreator = SucceedingAccountCreator()
        viewModel = AccountCreationViewModel(verificator: verificator, accountCreator: accountCreator)
    }
    
    private func givenViewModel(with verificator: InformationsVerificator) {
        let accountCreator = SucceedingAccountCreator()
        viewModel = AccountCreationViewModel(verificator: verificator, accountCreator: accountCreator)
    }

    private func whenCreatingAccount(email: String, password: String, passwordConfirmation: String) {
        viewModel.createAccount(email: email, password: password, passwordConfirmation: passwordConfirmation)
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
    
    private func thenVerifiedInformations(are expected: AccountCreationInformations) {
        XCTAssertEqual(expected, succeedingVerificator.accountCreationInformation)
    }
    
    private var viewModel: AccountCreationViewModel!
    private var succeedingVerificator: SucceedingInformationsVerificator!
    private var neverFinishingVerificator: NeverFinishingInformationsVerificator!
    private var verifiedInformations: AccountCreationInformations!
}

class SucceedingAccountCreator: AccountCreator {
    
    func createAccount(informations: AccountCreationInformations) -> VoidResult {
        return Just(())
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
    }
}

class FailingAccountCreator: AccountCreator {
    
    init(error: HTTPError) {
        self.error = error
    }
    
    private var error: HTTPError
    
    func createAccount(informations: AccountCreationInformations) -> VoidResult {
        AnyPublisher(Fail(error: HTTPError.from(statusCode: error.rawValue)))
    }
}

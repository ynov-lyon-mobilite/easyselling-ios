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

    func test_Sends_back_account_informations_when_asking_for_account_creation() async {
        givenViewModel(verificator: SucceedingInformationsVerificator())
        await whenCreatingAccount(email: "test@test.com", password: "password", passwordConfirmation: "password")
        thenVerifiedInformations(are: AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "password"))
    }
    
    func test_Sends_back_account_informations_when_asking_for_account_creation2() async {
        givenViewModel(verificator: SucceedingInformationsVerificator())
        thenViewModelState(is: .initial)
        await whenCreatingAccount(email: "test@test.com", password: "password", passwordConfirmation: "password")
        thenVerifiedInformations(are: AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "password"))
        thenViewModelState(is: .accountCreated)
    }

    // NEED TO THIS WITH CHRISTOPHE ROZ
//    func test_Shows_loader_when_informations_are_being_compute() {
//        givenViewModel(with: SucceedingInformationsVerificator())
//        Task {
//            await whenCreatingAccount(email: "test@test.com", password: "password", passwordConfirmation: "password")
//        }
//        thenViewModelState(is: .loading)
//
//    }

    func test_Show_error_when_informations_email_is_wrong() async {
        givenViewModel(with: FailingInformationsVerificator(error: .wrongEmail))
        await whenCreatingAccount(email: "test", password: "password", passwordConfirmation: "password")
        thenViewModelState(is: .initial)
        thenError(is: .wrongEmail)
    }


    func test_Show_error_when_informations_email_is_empty() async {
        givenViewModel(with: FailingInformationsVerificator(error: .emptyEmail))
        await whenCreatingAccount(email: "", password: "password", passwordConfirmation: "password")
        thenViewModelState(is: .initial)
        thenError(is: .emptyEmail)
    }

    func test_Show_error_when_informations_password_is_incorrect() async {
        givenViewModel(with: FailingInformationsVerificator(error: .wrongPassword))
        await whenCreatingAccount(email: "test", password: "password", passwordConfirmation: "differentPassword")
        thenViewModelState(is: .initial)
        thenError(is: .wrongPassword)
    }

    func test_Show_error_when_informations_password_is_empty() async {
        givenViewModel(with: FailingInformationsVerificator(error: .emptyPassword))
        await whenCreatingAccount(email: "test", password: "", passwordConfirmation: "password")
        thenViewModelState(is: .initial)
        thenError(is: .emptyPassword)
    }

    func test_Show_error_when_informations_password_confirmation_is_empty() async {
        givenViewModel(with: FailingInformationsVerificator(error: .emptyPasswordConfirmation))
        await whenCreatingAccount(email: "test", password: "password", passwordConfirmation: "")
        thenViewModelState(is: .initial)
        thenError(is: .emptyPasswordConfirmation)
    }

    func test_Shows_alert_when_an_error_occured_with_request() async {
        givenViewModel(verificator: SucceedingInformationsVerificator(), accountCreator: FailingAccountCreator(error: .forbidden))
        await whenCreatingAccount(email: "test", password: "password", passwordConfirmation: "password")
        thenViewModelState(is: .initial)
        thenAlert(is: .forbidden)
        XCTAssertTrue(viewModel.showAlert)
    }

    func test_Deinits_when_no_longer_interest() async {
        givenViewModel(with: SucceedingInformationsVerificator())
        await whenCreatingAccount(email: "test@test.com", password: "password", passwordConfirmation: "password")
        whenNoLongerInterested()
        XCTAssertNil(viewModel)
    }
    
    private func givenViewModel(verificator: SucceedingInformationsVerificator, accountCreator: AccountCreator = SucceedingAccountCreator()) {
        self.succeedingVerificator = verificator
        viewModel = AccountCreationViewModel(verificator: verificator, accountCreator: accountCreator)
    }
    
    private func givenViewModel(with verificator: InformationsVerificator) {
        let accountCreator = SucceedingAccountCreator()
        viewModel = AccountCreationViewModel(verificator: verificator, accountCreator: accountCreator)
    }

    private func whenCreatingAccount(email: String, password: String, passwordConfirmation: String) async {
        viewModel.email = email
        viewModel.password = password
        viewModel.passwordConfirmation = passwordConfirmation
        await viewModel.createAccount()
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
    
    private func thenAlert(is expected: APICallerError) {
        XCTAssertEqual(expected, viewModel.alert)
    }
    
    private var viewModel: AccountCreationViewModel!
    private var succeedingVerificator: SucceedingInformationsVerificator!
    private var verifiedInformations: AccountCreationInformations!
}

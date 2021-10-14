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
    
    func test_Shows_loader_when_informations_are_correct() {
        givenViewModel(with: SucceedingInformationsVerificator())
        whenVerifyingInformations(email: "test@test.com", password: "password", passwordConfirmation: "passwordConfirmation")
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
    
    private func givenViewModel(with verificator: InformationsVerificator) {
        viewModel = AccountCreationViewModel(verificator: verificator)
    }
    
    private func whenVerifyingInformations(email: String, password: String, passwordConfirmation: String) {
        viewModel.verifyInformations(email: email,
                                     password: password,
                                     passwordConfirmation: passwordConfirmation)
    }
    
    private func thenViewModelState(is expected: AccountCreationViewModel.AccountCreationState) {
        XCTAssertEqual(expected, viewModel.state)
    }
    
    private func thenError(is expected: AccountCreationError) {
        XCTAssertEqual(expected, viewModel.error)
    }
    
    private var viewModel: AccountCreationViewModel!
}

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
    
    /*
     Verification champs remplis
     verification mots de passe correspondant
     
     */
//
//    func test_Writes_all_informations_correctly() {
//        var isGoodInformations: Bool = false
//        let viewModel = AccountCreationViewModel(informationsVerificator: InformationsVerificator())
//        viewModel.verifyInformations(onFinish: {
//            switch $0 {
//            case .success(): isGoodInformations = true
//            case .failure(): break
//            }
//        })
//        XCTAssertTrue(isGoodInformations)
//    }
//}
}

class InformationsVerificator_Specs: XCTestCase {
    
    func test_Verifies_informations_are_good() {
        var isCorrectInformations = false
        let verificator = InformationsVerificator()
        let information = AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "password")
        verificator.verify(information, onVerified: {
            switch $0 {
            case let .success(isCorrect): return isCorrectInformations = isCorrect
            case .failure(_): break
            }
        })
        
        XCTAssertTrue(isCorrectInformations)
    }
    
    func test_Shows_error_when_passwords_are_not_matching() {
        var accountCreationError: String?
        let verificator = InformationsVerificator()
        let information = AccountCreationInformations(email: "test@test.com", password: "password", passwordConfirmation: "wrongPassword")
        verificator.verify(information, onVerified: {
            switch $0 {
            case .success(_): break
            case let .failure(error): accountCreationError = error.errorDescription
            }
        })
        XCTAssertEqual("Les mots de passes sont différents", accountCreationError)
    }
}

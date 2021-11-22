//
//  DefaultPasswordReseter_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 12/11/2021.
//

import Foundation
import XCTest
@testable import easyselling

class DefaultPasswordReseter_Specs: XCTestCase {
    
    func test_Resets_password_successfully() async {
        givenPasswordReseter()
        await whenResetingPassword(with: PasswordResetDTO(password: "Password", token: "Token"))
        thenPasswordIsSuccessfullyReset()
    }
    
    func test_Throws_error_when_password_reset_fail() async {
        givenPasswordReseter(with: FailingAPICaller(withError: 404))
        await whenResetingPassword(with: PasswordResetDTO(password: "password", token: "token"))
        thenError(is: .notFound)
    }
    
    private func givenPasswordReseter(with apiCaller: SucceedingAPICaller = SucceedingAPICaller()) {
        succeedingApiCaller = apiCaller
        passwordReseter = DefaultPasswordReseter(requestGenerator: FakeRequestGenerator(),
                                                     apiCaller: succeedingApiCaller)
    }
    
    private func givenPasswordReseter(with apiCaller: APICaller) {
        self.apiCaller = apiCaller
        passwordReseter = DefaultPasswordReseter(requestGenerator: FakeRequestGenerator(), apiCaller: apiCaller)
    }
    
    private func whenResetingPassword(with passwordResetInformations: PasswordResetDTO) async {
        do {
            try await passwordReseter.resetPassword(with: passwordResetInformations)
        } catch(let error) {
            self.error = error as? APICallerError
        }
    }
    
    private func thenPasswordIsSuccessfullyReset() {
        XCTAssertTrue(succeedingApiCaller.isCallSucceed)
    }
    
    private func thenError(is expected: APICallerError) {
        XCTAssertEqual(expected, error)
    }
    
    private var apiCaller: APICaller!
    private var succeedingApiCaller: SucceedingAPICaller!
    private var passwordReseter: DefaultPasswordReseter!
    private var error: APICallerError!
}

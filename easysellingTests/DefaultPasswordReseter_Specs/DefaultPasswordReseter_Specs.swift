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
        await whenResetingPassword(with: PasswordResetDTO())
        thenPasswordIsSuccessfullyReset()
    }
    
    private func givenPasswordReseter(with apiCaller: SucceedingAPICaller = SucceedingAPICaller()) {
        succeedingApiCaller = SucceedingAPICaller()
        passwordReseter = DefaultPasswordReseter(requestGenerator: FakeRequestGenerator(),
                                                     apiCaller: succeedingApiCaller)
    }
    
    private func whenResetingPassword(with passwordResetInformations: PasswordResetDTO) async {
        do {
            try await passwordReseter.resetPassword(with: passwordResetInformations)
        } catch {}
    }
    
    private func thenPasswordIsSuccessfullyReset() {
        XCTAssertTrue(succeedingApiCaller.isCallSucceed)
    }
    
    private var succeedingApiCaller: SucceedingAPICaller!
    private var passwordReseter: DefaultPasswordReseter!
}

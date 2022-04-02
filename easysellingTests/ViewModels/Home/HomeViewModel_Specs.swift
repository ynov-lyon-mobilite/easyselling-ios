//
//  HomeViewModel_Specs.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 09/03/2022.
//

import Foundation
import XCTest
@testable import easyselling

class HomeViewModel_Specs: XCTestCase {

    func test_Setups() {
        givenViewModel()
        XCTAssertEqual(.vehicles, viewModel.selectedTabItem)
    }

    func test_goes_back_when_user_want_to_logout() {
        givenViewModel()
        whenUserWantToLogout()
        thenUserHasLogout()
    }

    private func givenViewModel() {
        viewModel = HomeViewModel(onLogout: {
            self.hasLogout = true
        })
    }

    private func whenUserWantToLogout() {
        viewModel.onLogout()
    }

    private func thenUserHasLogout() {
        XCTAssertTrue(hasLogout)
    }

    private var viewModel: HomeViewModel!
    private var hasLogout: Bool = false
}

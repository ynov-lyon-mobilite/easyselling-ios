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
        let vm = HomeViewModel()
        XCTAssertEqual(.vehicles, vm.selectedTabItem)
    }
}

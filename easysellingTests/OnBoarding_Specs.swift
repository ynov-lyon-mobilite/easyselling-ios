//
//  onBoarding_Specs.swift
//  easysellingTests
//
//  Created by Pierre on 13/10/2021.
//

import XCTest
@testable import easyselling

class OnBoarding_Specs: XCTestCase {

    func test_Starts_OnBoarding() {
        givenScenario()
        whenBeginning()
        thenNavigationHistory(is: [.features])
    }
    
    
    private func givenScenario() {
        spyNavigator = SpyOnBoardingNavigator()
        scenario = OnBoardingScenario(navigator: spyNavigator)
    }
    
    private func whenBeginning() {
        scenario.begin()
    }
    
    private func thenNavigationHistory(is expected: [screens]) {
        XCTAssertEqual(expected, spyNavigator.history)
    }
    
    private var spyNavigator: SpyOnBoardingNavigator!
    private var scenario: OnBoardingScenario!
}

class SpyOnBoardingNavigator: OnBoardingNavigator {

    private(set) var history: [screens] = []
        
    func begin() {
        history.append(.features)
    }

}

enum screens {
    case features
}

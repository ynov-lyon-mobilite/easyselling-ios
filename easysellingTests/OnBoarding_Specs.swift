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
        thenNavigationHistory(is: [.screen1])
    }
    
    func test_Navigates_to_screen2() {
        givenScenario()
        whenBeginning()
        whenNavigatingToScreen2()
        thenNavigationHistory(is: [.screen1, .screen2])
    }
    
    func test_Navigates_to_screen3() {
        givenScenario()
        whenBeginning()
        whenNavigatingToScreen2()
        whenNavigatingToScreen3()
        thenNavigationHistory(is: [.screen1, .screen2, .screen3])
    }
    
    private func givenScenario() {
        spyNavigator = SpyOnBoardingNavigator()
        scenario = OnBoardingScenario(navigator: spyNavigator)
    }
    
    private func whenBeginning() {
        scenario.begin()
    }
    
    private func whenNavigatingToScreen2() {
        scenario.navigateToScreen2()
    }
    
    private func whenNavigatingToScreen3() {
        scenario.navigateToScreen3()
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
        history.append(.screen1)
    }
    
    func navigateToScreen2() {
        history.append(.screen2)
    }
    
    func navigateToScreen3() {
        history.append(.screen3)
    }
}

enum screens {
    case screen1
    case screen2
    case screen3
}

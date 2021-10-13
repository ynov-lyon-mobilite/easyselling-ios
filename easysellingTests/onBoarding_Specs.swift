//
//  onBoarding_Specs.swift
//  easysellingTests
//
//  Created by Pierre on 13/10/2021.
//

import XCTest
@testable import easyselling

class OnBoardingTests: XCTestCase {

    func test_Starts_OnBoarding() {
        var isBegin: Bool = false
        let onBoardingScenario = OnBoardingScenario()
        onBoardingScenario.begin {
            isBegin = true
        }
        XCTAssertTrue(isBegin)
    }
    
    func test_Nexts_OnBoarding() {
        var onNavigated: Bool = false
        let onBoardingScenario = OnBoardingScenario()
        onBoardingScenario.next {
            onNavigated = true
        }
        XCTAssertTrue(onNavigated)
    }
}

class OnBoardingScenario {
    func begin(onFinish: @escaping () -> Void) {
        onFinish()
    }
    
    func next(onFinish: @escaping () -> Void) {
        onFinish()
        print("TOTO\n")
    }
}

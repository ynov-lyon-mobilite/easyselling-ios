//
//  OnBoardingScenario_Specs.swift
//  easysellingTests
//
//  Created by Pierre on 13/10/2021.
//

import XCTest
@testable import easyselling

class OnBoardingScenario_Specs: XCTestCase {

    func test_Starts_OnBoarding() {
        givenScenario()
        whenBeginning()
        thenNavigationHistory(is: [.features])
    }
    
    func test_Finish_scenario() {
        givenScenario()
        whenBeginning()
        spyNavigator.onFinish?()
        thenScenarioIsFinished()
    }
    
    func test_Checks_OnBoarding_is_already_viewed() {
        givenScenario()
        whenBeginning()
        spyNavigator.onFinish?()
        givenScenario()
        whenBeginning()
        thenOnboardingIsViewed()
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
    
    private func thenScenarioIsFinished() {
        XCTAssertTrue(spyNavigator.scenarioDidFinished)
    }
    
    private func thenOnboardingIsViewed() {
        XCTAssertTrue(scenario.onBoardingIsViewed)
    }
    
    private var spyNavigator: SpyOnBoardingNavigator!
    private var scenario: OnBoardingScenario!
}

class SpyOnBoardingNavigator: OnBoardingNavigator {
        
    private(set) var scenarioDidFinished: Bool = false
    private(set) var history: [screens] = []
    private(set) var onFinish: Action?
        
    func navigatesToOnBoardingViewModel(onFinish: @escaping Action) {
        history.append(.features)
        self.onFinish = onFinish
    }
    
    func navigateToAuthenticationScenario() {
        scenarioDidFinished = true
    }
    
    func deleteStack() {}
}

enum screens {
    case features
}

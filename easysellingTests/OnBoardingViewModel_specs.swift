//
//  OnBoardingViewModel_specs.swift
//  easysellingTests
//
//  Created by Pierre on 13/10/2021.
//

import XCTest
@testable import easyselling

class OnBoardingViewModel_Specs: XCTestCase {
    
    func test_constructor_invalid_features_throws() {
        thenOnBoardingViewModelNotConstruct()
    }
    
    func test_constructor_default_values() {
        givenOnBoardingViewModel()
        thenCurrentFeatureViewModel(is: 0)
        thenViewModelSize(is: 3)
    }
    
    func test_Navigates_To_Second_Feature() {
        givenOnBoardingViewModel()
        whenNavigatingAtTheNextFeature()
        thenCurrentFeatureViewModel(is: 1)
    }
    
    func test_Navigates_To_Third_Feature() {
        givenOnBoardingViewModel()
        whenNavigatingAtTheNextFeature()
        whenNavigatingAtTheNextFeature()
        thenCurrentFeatureViewModel(is: 2)
    }
    
    func test_Navigates_After_Last_Feature() {
        givenOnBoardingViewModel()
        whenNavigatingAtTheNextFeature()
        whenNavigatingAtTheNextFeature()
        whenNavigatingAtTheNextFeature()
        thenCurrentFeatureViewModel(is: 2)
    }
    
    func test_Navigates_To_First_Feature_From_Second_Feature() {
        givenOnBoardingViewModel()
        whenNavigatingAtTheNextFeature()
        whenNavigatingAtThePreviousFeature()
        thenCurrentFeatureViewModel(is: 0)
    }
    
    func test_Navigates_To_Second_Feature_From_Third_Feature() {
        givenOnBoardingViewModel()
        whenNavigatingAtTheNextFeature()
        whenNavigatingAtTheNextFeature()
        whenNavigatingAtThePreviousFeature()
        thenCurrentFeatureViewModel(is: 1)
    }
    
    func test_Navigates_Before_First_Feature() {
        givenOnBoardingViewModel()
        whenNavigatingAtThePreviousFeature()
        thenCurrentFeatureViewModel(is: 0)
    }

    func givenOnBoardingViewModel() {
        do{
            let features: [Feature] = [
                Feature(title: "Page One"),
                Feature(title: "Page Two"),
                Feature(title: "Page Three")
            ]
            onBoardingViewModel = try OnBoardingViewModel(features: features)
        } catch {
            print("ERROR")
        }
    }
    
    func givenOnBoardingViewModelWithNoFeatures() throws {
        do{
            let features: [Feature] = []
            onBoardingViewModel = try OnBoardingViewModel(features: features)
        } catch {
            throw OnBoardingViewModelError.mustHaveAtLeastOnFeature
        }
    }

    func whenNavigatingAtTheNextFeature() {
        self.onBoardingViewModel.nextFeature()
    }
    
    func whenNavigatingAtThePreviousFeature() {
        self.onBoardingViewModel.previousFeature()
    }
    
    func thenCurrentFeatureViewModel(is expected: Int) {
        XCTAssertTrue(self.onBoardingViewModel.currentFeatureIndex == expected)
    }
    
    func thenViewModelSize(is expected: Int) {
        XCTAssertTrue(self.onBoardingViewModel.features.count == expected)
    }
    
    func thenOnBoardingViewModelNotConstruct() {
        XCTAssertThrowsError(try givenOnBoardingViewModelWithNoFeatures())
    }
    
    private var onBoardingViewModel: OnBoardingViewModel!
}



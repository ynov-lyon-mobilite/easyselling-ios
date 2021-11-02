//
//  OnBoardingViewModel_specs.swift
//  easysellingTests
//
//  Created by Pierre on 13/10/2021.
//

import XCTest
@testable import easyselling

class OnBoardingViewModel_Specs: XCTestCase {
    
    func test_Checks_init_with_features() {
        givenOnBoardingViewModel(withFeatures: [
            Feature(title: "title 1", image: "image 1", text: "text 1"),
            Feature(title: "title 2", image: "image 2", text: "text 2"),
            Feature(title: "title 3", image: "image 3", text: "text 3")
        ])
        thenFeatureCount(is: 3)
    }
    
    func test_Navigates_To_Second_Feature() {
        givenOnBoardingViewModel(withFeatures: [
            Feature(title: "title 1", image: "image 1", text: "text 1"),
            Feature(title: "title 2", image: "image 2", text: "text 2"),
            Feature(title: "title 3", image: "image 3", text: "text 3")
        ])
        thenShowedFeature(is: Feature(title: "title 1", image: "image 1", text: "text 1"))
        whenNavigatingAtTheNextFeature()
        thenShowedFeature(is: Feature(title: "title 2", image: "image 2", text: "text 2"))
        thenCurrentFeatureViewModel(is: 1)
    }
    
    func test_Navigates_To_Third_Feature() {
        givenOnBoardingViewModel(withFeatures: [
            Feature(title: "title 1", image: "image 1", text: "text 1"),
            Feature(title: "title 2", image: "image 2", text: "text 2"),
            Feature(title: "title 3", image: "image 3", text: "text 3")
        ])
        whenNavigatingAtTheNextFeature()
        whenNavigatingAtTheNextFeature()
        thenShowedFeature(is: Feature(title: "title 3", image: "image 3", text: "text 3"))
        thenCurrentFeatureViewModel(is: 2)
    }
    
    func test_Navigates_To_First_Feature_From_Second_Feature() {
        givenOnBoardingViewModel(withFeatures: [
            Feature(title: "title 1", image: "image 1", text: "text 1"),
            Feature(title: "title 2", image: "image 2", text: "text 2"),
            Feature(title: "title 3", image: "image 3", text: "text 3")
        ])
        whenNavigatingAtTheNextFeature()
        thenShowedFeature(is: Feature(title: "title 2", image: "image 2", text: "text 2"))
        whenNavigatingAtThePreviousFeature()
        thenShowedFeature(is: Feature(title: "title 1", image: "image 1", text: "text 1"))
        thenCurrentFeatureViewModel(is: 0)
    }
    
    func test_Disables_previous_button_when_on_first_feature() {
        givenOnBoardingViewModel(withFeatures: [
            Feature(title: "title 1", image: "image 1", text: "text 1"),
            Feature(title: "title 2", image: "image 2", text: "text 2"),
            Feature(title: "title 3", image: "image 3", text: "text 3")
        ])
        whenCurrentFeatureShown(is: 0)
        XCTAssertFalse(onBoardingViewModel.isShowingPreviousButton)
    }
    
    func test_Enables_previous_button_when_not_on_first_feature() {
        givenOnBoardingViewModel(withFeatures: [
            Feature(title: "title 1", image: "image 1", text: "text 1"),
            Feature(title: "title 2", image: "image 2", text: "text 2"),
            Feature(title: "title 3", image: "image 3", text: "text 3")
        ])
        whenCurrentFeatureShown(is: 1)
        XCTAssertTrue(onBoardingViewModel.isShowingPreviousButton)
    }
    
    func test_Enables_previous_button_when_not_on_first_feature2() {
        givenOnBoardingViewModel(withFeatures: [
            Feature(title: "title 1", image: "image 1", text: "text 1"),
            Feature(title: "title 2", image: "image 2", text: "text 2"),
            Feature(title: "title 3", image: "image 3", text: "text 3")
        ])
        whenCurrentFeatureShown(is: 2)
        XCTAssertTrue(onBoardingViewModel.isShowingPreviousButton)
    }
    
    func test_Tries_to_go_to_next_feature_when_there_is_not_more() {
        givenOnBoardingViewModel(withFeatures: [
            Feature(title: "title 1", image: "image 1", text: "text 1"),
            Feature(title: "title 2", image: "image 2", text: "text 2"),
            Feature(title: "title 3", image: "image 3", text: "text 3")
        ])
        whenCurrentFeatureShown(is: 2)
        whenNavigatingAtTheNextFeature()
        thenCurrentFeatureViewModel(is: 2)
    }
    
    func test_Clicks_on_skip_in_the_first_feature(){
        givenOnBoardingViewModel(withFeatures: [
            Feature(title: "title 1", image: "image 1", text: "text 1"),
            Feature(title: "title 2", image: "image 2", text: "text 2"),
            Feature(title: "title 3", image: "image 3", text: "text 3")
        ])
        whenCurrentFeatureShown(is: 0)
        whenSkippingFeatures()
        thenCurrentFeatureViewModel(is: 2)
    }
    
    func test_Enables_skip_button_when_not_on_last_feature(){
        givenOnBoardingViewModel(withFeatures: [
            Feature(title: "title 1", image: "image 1", text: "text 1"),
            Feature(title: "title 2", image: "image 2", text: "text 2"),
            Feature(title: "title 3", image: "image 3", text: "text 3")
        ])
        whenCurrentFeatureShown(is: 0)
        XCTAssertTrue(onBoardingViewModel.isShowingSkipButton)
    }
    
    func test_Clicks_on_skip_in_the_second_feature(){
        givenOnBoardingViewModel(withFeatures: [
            Feature(title: "title 1", image: "image 1", text: "text 1"),
            Feature(title: "title 2", image: "image 2", text: "text 2"),
            Feature(title: "title 3", image: "image 3", text: "text 3")
        ])
        whenCurrentFeatureShown(is: 1)
        whenSkippingFeatures()
        thenCurrentFeatureViewModel(is: 2)
    }
    
    func test_Enables_skip_button_when_not_on_last_feature2(){
        givenOnBoardingViewModel(withFeatures: [
            Feature(title: "title 1", image: "image 1", text: "text 1"),
            Feature(title: "title 2", image: "image 2", text: "text 2"),
            Feature(title: "title 3", image: "image 3", text: "text 3")
        ])
        whenCurrentFeatureShown(is: 1)
        XCTAssertTrue(onBoardingViewModel.isShowingSkipButton)
    }
    
    func test_Disables_skip_button_when_on_last_feature(){
        givenOnBoardingViewModel(withFeatures: [
            Feature(title: "title 1", image: "image 1", text: "text 1"),
            Feature(title: "title 2", image: "image 2", text: "text 2"),
            Feature(title: "title 3", image: "image 3", text: "text 3")
        ])
        whenCurrentFeatureShown(is: 2)
        XCTAssertFalse(onBoardingViewModel.isShowingSkipButton)
    }
    
    private func givenOnBoardingViewModel(withFeatures features: [Feature]) {
        onBoardingViewModel = OnBoardingViewModel(features: features)
    }

    private func whenNavigatingAtTheNextFeature() {
        self.onBoardingViewModel.nextFeature()
    }
    
    private func whenNavigatingAtThePreviousFeature() {
        self.onBoardingViewModel.previousFeature()
    }
    
    private func whenCurrentFeatureShown(is featureIndex: Int) {
        onBoardingViewModel.currentFeatureIndex = featureIndex
    }
    
    private func whenSkippingFeatures(){
        self.onBoardingViewModel.skipFeatures()
    }
    
    private func thenShowedFeature(is expected: Feature) {
        XCTAssertEqual(expected, onBoardingViewModel.feature)
    }
    
    private func thenCurrentFeatureViewModel(is expected: Int) {
        XCTAssertTrue(self.onBoardingViewModel.currentFeatureIndex == expected)
    }
    
    private func thenFeatureCount(is expected: Int) {
        XCTAssertTrue(self.onBoardingViewModel.features.count == expected)
    }
    
    private var onBoardingViewModel: OnBoardingViewModel!
}

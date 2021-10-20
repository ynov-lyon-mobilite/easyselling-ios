//
//  OnBoardingViewModel_specs.swift
//  easysellingTests
//
//  Created by Pierre on 13/10/2021.
//

import XCTest
@testable import easyselling

class OnBoardingViewModel_Specs: XCTestCase {
    
    /*
     Tester : En page 0 il se passe rien quand on revient en arrière
              En en denière page il se passe rien quand on appuie sur next
              Qu'importe la page sauf la dernière on peut être renvoyé à la dernière page (bouton skip)
              Créer un page indicator (nombre de pages), qu'il indique la bonne page
     
     Design : Bouton next, previous et skip / dernière page next devient continuer et pas de bouton skip, première page pas de bouton previous
              Page indicator (point nbr de pages - grisés le bon est coloré)
              Pas de feature message d'error
     */
    
    func test_Asserts_that_empty_features_return_error() {
        givenOnBoardingViewModel(withFeatures: [])
        XCTAssertEqual("error", onBoardingViewModel.featuresIsEmpty)
    }
    
    func test_Asserts_feature_is_not_show_when_features_are_empty() {
        givenOnBoardingViewModel(withFeatures: [])
        XCTAssertNil(onBoardingViewModel.feature)
    }
    
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
    
//    func test_Navigates_After_Last_Feature() {
//     givenOnBoardingViewModel(withFeatures: [
//         Feature(title: "title 1", image: "image 1", text: "text 1"),
//         Feature(title: "title 2", image: "image 2", text: "text 2"),
//         Feature(title: "title 3", image: "image 3", text: "text 3")
//     ])
//        whenNavigatingAtTheNextFeature()
//        whenNavigatingAtTheNextFeature()
//        whenNavigatingAtTheNextFeature()
//        thenCurrentFeatureViewModel(is: 2)
//    }
//
//    func test_Navigates_Before_First_Feature() {
//        givenOnBoardingViewModel(withFeatures: [
//            Feature(title: "title 1", image: "image 1", text: "text 1"),
//            Feature(title: "title 2", image: "image 2", text: "text 2"),
//            Feature(title: "title 3", image: "image 3", text: "text 3")
//        ])
//        whenNavigatingAtThePreviousFeature()
//        thenCurrentFeatureViewModel(is: 0)
//    }

    func givenOnBoardingViewModel(withFeatures features: [Feature]) {
        onBoardingViewModel = OnBoardingViewModel(features: features)
    }

    func whenNavigatingAtTheNextFeature() {
        self.onBoardingViewModel.nextFeature()
    }
    
    func whenNavigatingAtThePreviousFeature() {
        self.onBoardingViewModel.previousFeature()
    }
    
    private func thenShowedFeature(is expected: Feature) {
        XCTAssertEqual(expected, onBoardingViewModel.feature)
    }
    
    func thenCurrentFeatureViewModel(is expected: Int) {
        XCTAssertTrue(self.onBoardingViewModel.currentFeatureIndex == expected)
    }
    
    func thenFeatureCount(is expected: Int) {
        XCTAssertTrue(self.onBoardingViewModel.features.count == expected)
    }
    
    private var onBoardingViewModel: OnBoardingViewModel!
}

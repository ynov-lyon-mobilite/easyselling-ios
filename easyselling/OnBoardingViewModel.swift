//
//  OnBoardingViewModel.swift
//  easyselling
//
//  Created by Pierre on 13/10/2021.
//

import Foundation
import SwiftUI

enum OnBoardingViewModelError : Error {
    case mustHaveAtLeastOnFeature
}

class OnBoardingViewModel: ObservableObject {

    var features: [Feature]
    @Published var currentFeatureIndex: Int = 0
    
    var feature: Feature { features[currentFeatureIndex] }
    var isShowingPreviousButton: Bool { currentFeatureIndex == 0 ? false : true }
    var isShowingSkipButton: Bool { (currentFeatureIndex == features.count - 1) ? false : true }
    
    init(features: [Feature]) {
        self.features = features
    }
    
    func nextFeature() {
        if(!(currentFeatureIndex == self.features.count - 1)) {
            currentFeatureIndex += 1
        }
    }
    
    func previousFeature() {
        if(!(currentFeatureIndex == 0)) {
            currentFeatureIndex -= 1
        }
    }
    
    func skipFeatures(){
        if(!(currentFeatureIndex == features.count - 1)){
            currentFeatureIndex = features.count - 1
        }
    }
}

struct Feature: Equatable, Hashable {
    let title: String
    let image: String
    let text: String
}

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
    var feature: Feature? {
        if featuresIsEmpty == "error" {
            return nil
        }
        return features[currentFeatureIndex]
    }
    var featuresIsEmpty: String {
        if features.isEmpty {
            return "error"
        }
        return ""
    }
    var currentFeatureIndex: Int = 0
    
    init(features: [Feature]) {
        self.features = features
    }
    
//    func readCurrentFeature() -> Feature {
//        return features[currentFeatureIndex]
//    }
    
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
}

struct Feature: Equatable {
    let title: String
    let image: String
    let text: String
}

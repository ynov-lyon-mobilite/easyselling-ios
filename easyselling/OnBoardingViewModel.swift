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

    private(set) var features: [Feature]
    @Published private(set) var currentFeatureIndex: Int
    
    init(features: [Feature]) /*throws*/ {
        /*if features.isEmpty {
            throw OnBoardingViewModelError.mustHaveAtLeastOnFeature
        }*/
        self.currentFeatureIndex = 0
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

struct Feature {
    let title: String
    let image: String
}

//
//  OnBoardingViewModel.swift
//  easyselling
//
//  Created by Pierre on 13/10/2021.
//

import Foundation
import SwiftUI

class OnBoardingViewModel: ObservableObject {

    var features: [Feature]
    @Published var currentFeatureIndex: Int = 0

    var feature: Feature { features[currentFeatureIndex] }
    var isShowingPreviousButton: Bool { currentFeatureIndex != 0 }
    var isLastFeature: Bool { currentFeatureIndex == (features.count - 1) }
    private var onFinish: Action

    init(features: [Feature], onFinish: @escaping Action) {
        self.features = features
        self.onFinish = onFinish
    }

    func nextFeature() {
        if(currentFeatureIndex != (features.count - 1)) {
            currentFeatureIndex += 1
        } else {
            onFinish()
        }
    }

    func previousFeature() {
        if(currentFeatureIndex != 0) {
            currentFeatureIndex -= 1
        }
    }

    func skipFeatures() {
        onFinish()
    }
}

struct Feature: Equatable, Hashable {
    let title: String
    let image: String
    let text: String
}

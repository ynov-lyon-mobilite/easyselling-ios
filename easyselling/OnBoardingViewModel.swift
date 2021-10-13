//
//  OnBoardingViewModel.swift
//  easyselling
//
//  Created by Pierre on 13/10/2021.
//

import Foundation

class OnBoardingViewModel: ObservableObject {

    private var features: [Feature]
    
    init(features: [Feature]) {
        self.features = features
    }
    
}

struct Feature {
    var title: String
}

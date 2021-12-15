//
//  OnBoardingScenario.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation
import SwiftUI

class OnBoardingScenario {

    @AppStorage("onBoardingIsViewed") var onBoardingIsViewed: Bool = false

    init(navigator: OnBoardingNavigator) {
        self.navigator = navigator
    }

    private var navigator: OnBoardingNavigator

    func begin() {
        navigator.navigatesToOnBoardingViewModel(onFinish: hasFinish)
    }

    private func hasFinish() {
        self.onBoardingIsViewed = true
        navigator.closeOnBoarding()
    }

    private func navigateToAuthenticationScenario() {
        navigator.closeOnBoarding()
    }
}

//
//  OnBoardingScenario.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation
import UIKit
import SwiftUI

class OnBoardingScenario {

    @AppStorage("onBoardingIsViewed") var onBoardingIsViewed: Bool = false

    init(navigator: OnBoardingNavigator) {
        self.navigator = navigator
    }

    private var navigator: OnBoardingNavigator

    func begin() {
//        if(!onBoardingIsViewed) {
        navigator.navigatesToOnBoardingViewModel(onFinish: hasFinish)
//        } else {
//            navigator.navigateToAuthenticationScenario()
//        }
    }

    private func hasFinish() {
        self.onBoardingIsViewed = true
        navigator.navigateToAuthenticationScenario()
    }

    private func navigateToAuthenticationScenario() {
        navigator.navigateToAuthenticationScenario()
    }
}

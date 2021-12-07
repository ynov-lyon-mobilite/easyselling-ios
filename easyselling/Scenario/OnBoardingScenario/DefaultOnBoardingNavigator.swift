//
//  DefaultOnBoardingNavigator.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 14/11/2021.
//

import Foundation
import UIKit
import SwiftUI

protocol OnBoardingNavigator {
    func navigatesToOnBoardingViewModel(onFinish: @escaping Action)
    func navigateToAuthenticationScenario()
}

class DefaultOnBoardingNavigator: OnBoardingNavigator {

    init(navigationController: UINavigationController, window: UIWindow?) {
        self.navigationController = navigationController
        self.window = window
    }

    private var navigationController: UINavigationController
    private var window: UIWindow?

    func navigatesToOnBoardingViewModel(onFinish: @escaping Action) {
        let viewModel = OnBoardingViewModel(features: [
            Feature(title: L10n.OnBoarding.Features._1.title, image: Asset.OnBoarding.first.name, text: L10n.OnBoarding.Features._1.label),
            Feature(title: L10n.OnBoarding.Features._2.title, image: Asset.OnBoarding.second.name, text: L10n.OnBoarding.Features._2.label),
            Feature(title: L10n.OnBoarding.Features._3.title, image: Asset.OnBoarding.third.name, text: L10n.OnBoarding.Features._3.label)
        ], onFinish: onFinish)
        let onBoardingView = OnBoardingView(viewModel: viewModel)
        let view: UIViewController = UIHostingController(rootView: onBoardingView)
        navigationController.pushViewController(view, animated: true)
    }

    func navigateToAuthenticationScenario() {
        let navigator = DefaultAuthenticationNavigator(window: window)
        let scenario = AuthenticationScenario(navigator: navigator)
        scenario.begin(from: .default)
    }
}

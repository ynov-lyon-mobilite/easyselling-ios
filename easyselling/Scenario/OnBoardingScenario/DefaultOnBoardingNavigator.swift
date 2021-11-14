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
                Feature(title: "Page One", image: "pencil", text: "Lorem ipsum dolor sit amet. Ea nihil veritatis et labore molestias eum rerum excepturi"),
                Feature(title: "Page Two", image: "scribble", text: "Lorem ipsum dolor sit amet. Ea nihil veritatis et labore molestias eum rerum excepturi"),
                Feature(title: "Page Three", image: "trash", text: "Lorem ipsum dolor sit amet. Ea nihil veritatis et labore molestias eum rerum excepturi")], onFinish: onFinish)
            let onBoardingView = OnBoardingView(viewModel: viewModel)
            let view: UIViewController = UIHostingController(rootView: onBoardingView)
            navigationController.pushViewController(view,
                                                    animated: true)
    }

    func navigateToAuthenticationScenario() {
        let navigator = DefaultAuthenticationNavigator(window: window)
        let scenario = AuthenticationScenario(navigator: navigator)
        scenario.begin(from: .default)
    }
}

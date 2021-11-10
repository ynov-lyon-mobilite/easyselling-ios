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
        if(!onBoardingIsViewed) {
            navigator.navigatesToOnBoardingViewModel(onFinish: hasFinish)
        } else {
            navigator.navigateToAuthenticationScenario()
        }
    }
    
    private func hasFinish() {
        self.onBoardingIsViewed = true
        navigator.navigateToAuthenticationScenario()
    }
    
    private func navigateToAuthenticationScenario() {
        navigator.navigateToAuthenticationScenario()
    }
}

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
        scenario.begin()
    }
}

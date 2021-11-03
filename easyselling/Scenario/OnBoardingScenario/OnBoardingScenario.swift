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
        navigator.deleteStack()
        navigator.navigateToAuthenticationScenario()
    }
    
    private func navigateToAuthenticationScenario() {
        navigator.navigateToAuthenticationScenario()
    }
}

protocol OnBoardingNavigator {
    func navigatesToOnBoardingViewModel(onFinish: @escaping Action)
    func navigateToAuthenticationScenario()
    func deleteStack()
}

class DefaultOnBoardingNavigator: OnBoardingNavigator {
  
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    private var navigationController: UINavigationController

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
        let navigator = DefaultAuthenticationNavigator(navigationController: navigationController)
        let scenario = AuthenticationScenario(navigator: navigator)
        scenario.begin()
    }
    
    func deleteStack() {
        self.navigationController.viewControllers.removeAll()
    }
}

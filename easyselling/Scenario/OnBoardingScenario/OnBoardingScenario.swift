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
    
    init(navigator: OnBoardingNavigator) {
        self.navigator = navigator
    }
    
    private var navigator: OnBoardingNavigator
    
    func begin() {
        // Vérifier si l'utilisateur à déjà vu un onboarding
        navigator.navigatesToOnBoardingViewModel(onFinish: navigateToAuthenticationScenario)
    }
    
    private func hasFinish() {
        // sauvegarder le fait que l'utilisateur à fait le onboarding pour la première fois
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
}

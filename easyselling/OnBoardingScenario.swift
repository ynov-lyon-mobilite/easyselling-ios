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
        navigator.begin()
    }

}

protocol OnBoardingNavigator {
    func begin()

}

class DefaultOnBoardingNavigator: OnBoardingNavigator {

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    private var navigationController: UINavigationController

    func begin() {
        let viewModel = OnBoardingViewModel()
        let onBoardingFirstPage = OnBoardingFirstPage(viewModel: viewModel)
        let view: UIViewController = UIHostingController(rootView: onBoardingFirstPage)
        navigationController.pushViewController(view,
                                                animated: true)
    }

}

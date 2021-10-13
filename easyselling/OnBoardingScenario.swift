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
    
    func navigateToScreen2() {
        navigator.navigateToScreen2()
    }
    
    func navigateToScreen3() {
        navigator.navigateToScreen3()
    }
}

protocol OnBoardingNavigator {
    func begin()
    func navigateToScreen2()
    func navigateToScreen3()
}

class DefaultOnBoardingNavigator: OnBoardingNavigator {

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    private var navigationController: UINavigationController

    func begin() {
        let onBoardingFirstPage = OnBoardingFirstPage()
        let view: UIViewController = UIHostingController(rootView: onBoardingFirstPage)
        navigationController.pushViewController(view,
                                                animated: true)
    }
    
    func navigateToScreen2() {
        
    }
    
    func navigateToScreen3() {
        
    }
}

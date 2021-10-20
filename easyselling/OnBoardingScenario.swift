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
        /*do {*/
            let viewModel = /*try*/ OnBoardingViewModel(features: [
                Feature(title: "Page One", image: "Lucas"),
                Feature(title: "Page Two", image: "Bafabière"),
                Feature(title: "Page Three", image: "OhYeah")])
            let onBoardingView = OnBoardingView(viewModel: viewModel)
            let view: UIViewController = UIHostingController(rootView: onBoardingView)
            navigationController.pushViewController(view,
                                                    animated: true)
        /*} catch {
           print("ERROR")
        }*/
    }
}

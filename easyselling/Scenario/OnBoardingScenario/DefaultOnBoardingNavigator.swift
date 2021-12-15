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
    func closeOnBoarding()
}

class DefaultOnBoardingNavigator: OnBoardingNavigator {

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    private var navigationController: UINavigationController

    func navigatesToOnBoardingViewModel(onFinish: @escaping Action) {
        let viewModel = OnBoardingViewModel(features: [
            Feature(title: L10n.OnBoarding.Features._1.title, image: Asset.OnBoarding.first.name, text: L10n.OnBoarding.Features._1.label),
            Feature(title: L10n.OnBoarding.Features._2.title, image: Asset.OnBoarding.second.name, text: L10n.OnBoarding.Features._2.label),
            Feature(title: L10n.OnBoarding.Features._3.title, image: Asset.OnBoarding.third.name, text: L10n.OnBoarding.Features._3.label)
        ], onFinish: onFinish)
        let onBoardingView = OnBoardingView(viewModel: viewModel)
        let view: UIViewController = UIHostingController(rootView: onBoardingView)
        view.modalPresentationStyle = .fullScreen
        navigationController.present(view, animated: true)
    }

    func closeOnBoarding() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}

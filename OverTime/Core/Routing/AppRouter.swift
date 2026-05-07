//
//  AppRouter.swift
//  OverTime
//
//  Created by Mona Zarea on 06/05/2026.
//

import Foundation
import UIKit

final class AppRouter: AppRouterProtocol {

    private let navigationController: UINavigationController
    private let container: DependencyContainerProtocol

    init(navigationController: UINavigationController,
         container: DependencyContainerProtocol) {
        self.navigationController = navigationController
        self.container = container
    }

    func showSplash() {
        let vc = container.makeSplashViewController(router: self)
        navigationController.setViewControllers([vc], animated: false)
    }	

    func showOnboarding() {
       print("onboarding")
    }

    func showHome() {
       print("Home")
    }
}

//
//  AppRouter.swift
//  OverTime
//
//  Created by Mona Zarea on 06/05/2026.
//

import Foundation
import UIKit

final class AppRouter: AppRouterProtocol {

    private weak var root: RootContainerViewController?
    private let container: DependencyContainerProtocol

    init(root : RootContainerViewController,
         container: DependencyContainerProtocol) {
        self.root = root
        self.container = container
    }

    func showSplash() {
        let vc = container.makeSplashViewController(router: self)
        root?.transition(to: vc)
        //navigationController.setViewControllers([vc], animated: false)
    }

    func showOnboarding() {
       print("onboarding")
    }
    
    // onboardig will be like that
//    func showOnboarding() {
//            let nav = UINavigationController()
//            let vc  = container.makeOnboardingViewController(router: self)
//            nav.setViewControllers([vc], animated: false)
//            root?.transition(to: nav, duration: 0.3)
//        }


    func showMainTabBar() {
        let tabBar = container.makeMaingTabBarController(router: self)
            root?.transition(to: tabBar, duration: 0.3)
        }
}

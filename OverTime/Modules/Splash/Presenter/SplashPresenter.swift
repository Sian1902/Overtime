//
//  SplashPresenter.swift
//  OverTime
//
//  Created by Mona Zarea on 06/05/2026.
//

import Foundation


final class SplashPresenter: SplashPresenterProtocol {

    private weak var view: SplashView?
    private let router: AppRouterProtocol
    private let userDefault : UserDefaultsManagerProtocol

    init(router: AppRouterProtocol, userdefault: UserDefaultsManagerProtocol) {
        self.router = router
        self.userDefault = userdefault
    }

    func attachView(_ view: SplashView) {
        self.view = view
    }

    
    func animationDidFinished() {
//        if userDefault.hasSeenOnboarding {
//            router.showHome()
//        } else {
//            router.showOnboarding()
//        }
        router.showSportsScreen()
    }
}

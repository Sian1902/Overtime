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

    init(router: AppRouterProtocol) {
        self.router = router
    }

    func attachView(_ view: SplashView) {
        self.view = view
    }

    func viewDidLoad() {
        // navigate to onboarding or home depends on islogedin
    }
    
    func animationDidFinished() {
        
    }
}

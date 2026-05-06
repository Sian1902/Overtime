//
//  DependencyContainer.swift
//  OverTime
//
//  Created by Mona Zarea on 06/05/2026.
//

import UIKit

final class DependencyContainer: DependencyContainerProtocol{
    
    
    func makeSplashViewController(router: any AppRouterProtocol) -> UIViewController {
        let presenter = SplashPresenter(router : router)
        let vc = SplashViewController(presenter: presenter, nibName: String(describing: SplashViewController.self))
        presenter.attachView(vc)
        return vc
    }
    

}

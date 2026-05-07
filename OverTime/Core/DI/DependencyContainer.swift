// DependencyContainer.swift
import UIKit

final class DependencyContainer: DependencyContainerProtocol {
    
    private lazy var userDefault: UserDefaultsManagerProtocol = UserDefaultManager()

    func makeSplashViewController(router: AppRouterProtocol) -> UIViewController {
        let presenter = SplashPresenter(router: router, userdefault: userDefault)
        let vc = SplashViewController(
            presenter: presenter,
            nibName: String(describing: SplashViewController.self)
        )
        presenter.attachView(vc)
        return vc
    }

    func makeSplashViewController<T: AppRouterProtocol>(router: T) -> UIViewController {
        return makeSplashViewController(router: router as AppRouterProtocol)
    }
}

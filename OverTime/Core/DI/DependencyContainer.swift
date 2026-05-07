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
    
    func makeSportsViewController(router: AppRouterProtocol) -> UIViewController {
        let presenter = SportsPresenter(router: router)
        let vc = SportsCollectionViewController(presenter: presenter)
        presenter.attachView(vc)
        return vc
    }
}

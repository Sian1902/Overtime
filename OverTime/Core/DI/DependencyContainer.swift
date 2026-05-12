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
    
    func makeMainTabBarController(router: AppRouterProtocol) -> UIViewController {
        let tabBar = UITabBarController()
        let sports = makeSportsViewController(router: router)
        let favorites = makeFavoritesViewController(router: router)
        return TabBarConfigurator.configure(tabBar: tabBar, sports: sports, favorites: favorites)
    }
    
    func makeSportsViewController(router: AppRouterProtocol) -> UIViewController {
        let presenter = SportsPresenter(router: router)
        let vc = SportsCollectionViewController(presenter: presenter)
        presenter.attachView(vc)
        return vc
    }
    	
    func makeFavoritesViewController(router: AppRouterProtocol) -> UIViewController {
        let presenter = FavoritesPresenter(router: router)
        let vc = LeagueViewController.create(presenter: presenter)
        return vc
    }

    func makeTeamDetailsViewController(router: AppRouterProtocol, team: Team, sport: SportType) -> UIViewController {
        let presenter = TeamDetailsPresenter(router: router, apiManager: SportsAPIManager.shared, team: team, sport: sport)
        let vc = DetailsViewController.create(presenter: presenter)
        return vc
    }

}

import Foundation
import UIKit

final class AppRouter: AppRouterProtocol {

    private weak var root: RootContainerViewController?
    private let container: DependencyContainerProtocol

    init(root: RootContainerViewController, container: DependencyContainerProtocol) {
        self.root = root
        self.container = container
    }

    func showSplash() {
        let vc = container.makeSplashViewController(router: self)
        root?.transition(to: vc)
    }

    func showOnboarding() {
        print("onboarding")
    }

    func showMainTabBar() {
        let tabBar = container.makeMainTabBarController(router: self)
        root?.transition(to: tabBar, duration: 0.3)
    }

    func showLeagues(sport: SportType, navigationController: UINavigationController) {
        let presenter = AllLeaguesPresenter(router: self, sport: sport)
        let vc = LeagueViewController.create(presenter: presenter, sport: sport)
        presenter.attachView(vc)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    func showLeagueDetails(league: League, sport: SportType, navigationController: UINavigationController) {
        let presenter = LeagueDetailsPresenter(router: self, league: league, sport: sport)
        let vc = DetailsViewController.create(presenter: presenter)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
}    

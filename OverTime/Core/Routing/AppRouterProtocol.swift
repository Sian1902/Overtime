import UIKit
import Foundation

protocol AppRouterProtocol {
    func showSplash()
    func showOnboarding()
    func showMainTabBar()
    func showLeagues(sport: SportType, navigationController: UINavigationController)
    func showLeagueDetails(league: League, sport: SportType, navigationController: UINavigationController)
    func showTeamDetails(team : Team, sport: SportType, navigationController:
        UINavigationController)
}

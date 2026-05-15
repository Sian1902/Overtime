import UIKit
import Foundation

protocol AppRouterProtocol {
    func showSplash()
    func showOnboarding()
    func showMainTabBar()
    func showLeagues(sport: SportType)
    func showLeagueDetails(league: League, sport: SportType )
    func showTeamDetails(team : Team, sport: SportType
        )
}

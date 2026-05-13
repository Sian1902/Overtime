import Foundation
import UIKit

class AllLeaguesPresenter: LeaguePresenterProtocol {

    private weak var view: LeagueView?
    private let router: AppRouterProtocol
    private let sport: SportType
    private let database: DatabaseManagerProtocol
    private var leagues: [League] = []
    private weak var navigationController: UINavigationController?

    init(router: AppRouterProtocol, sport: SportType, database: DatabaseManagerProtocol = DatabaseManager()) {
        self.router = router
        self.sport = sport
        self.database = database
    }

    func attachView(_ view: LeagueView) {
        self.view = view
        self.navigationController = (view as? UIViewController)?.navigationController
    }

    func loadLeagues() {
        SportsAPIManager.shared.fetchLeagues(sport: sport) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.showEmptyState(false)
                switch result {
                case .success(let leagues):
                    self?.leagues = leagues
                    self?.view?.showLeagues(leagues)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }

    func leaguesCount() -> Int { return leagues.count }

    func getLeague(at index: Int) -> League { return leagues[index] }

    func didSelectLeague(at index: Int) {
        guard let navigationController = navigationController else { return }
        let league = leagues[index]
        router.showLeagueDetails(league: league, sport: sport, navigationController: navigationController)
    }

    func toggleFavorite(at index: Int) {
        let league = leagues[index]
        guard let key = league.leagueKey else { return }
        if database.isLeagueFavorite(with: key) {
            try? database.delete(by: key)
            view?.updateFavoriteButton(at: index, isFavorite: false)
        } else {
            let favorite = FavoriteLeague(
                leagueKey: key,
                leagueName: league.leagueName ?? "",
                leagueYear: league.leagueYear ?? "",
                leagueSeason: league.leagueSeason ?? "",
                leagueLogo: league.leagueLogo ?? league.leagueBadge ?? "",
                countryLogo: league.countryLogo ?? "",
                countryKey: league.countryKey ?? 0,
                countryName: league.countryName ?? "",
                leagueBadge: league.leagueBadge ?? league.leagueLogo ?? "",
                sportType: sport
            )
            try? database.save(league: favorite)
            view?.updateFavoriteButton(at: index, isFavorite: true)
        }
    }

    func isFavorite(at index: Int) -> Bool {
        guard let key = leagues[index].leagueKey else { return false }
        return database.isLeagueFavorite(with: key)
    }
}

import Foundation
import UIKit
import Network

class FavoritesPresenter: LeaguePresenterProtocol {

    private weak var view: LeagueView?
    private let router: AppRouterProtocol
    private let database: DatabaseManagerProtocol
    private var leagues: [League] = []
    private var favorites: [FavoriteLeague] = []
    private weak var navigationController: UINavigationController?

    init(router: AppRouterProtocol, database: DatabaseManagerProtocol = DatabaseManager()) {
        self.router = router
        self.database = database
    }

    func attachView(_ view: LeagueView) {
        self.view = view
        self.navigationController = (view as? UIViewController)?.navigationController
    }

    func loadLeagues() {
        do {
            favorites = try database.fetchAllLeagues()
            leagues = favorites.map { favorite in
                League(
                    leagueKey: favorite.leagueKey,
                    leagueName: favorite.leagueName,
                    leagueYear: favorite.leagueYear,
                    leagueSeason: favorite.leagueSeason,
                    leagueLogo: favorite.leagueLogo,
                    countryLogo: favorite.countryLogo,
                    countryKey: favorite.countryKey,
                    countryName: favorite.countryName,
                    leagueBadge: favorite.leagueBadge
                )
            }
            view?.showLeagues(leagues)
            view?.showEmptyState(leagues.isEmpty)
        } catch {
            view?.showError(error.localizedDescription)
        }
    }

    func leaguesCount() -> Int { return leagues.count }

    func getLeague(at index: Int) -> League { return leagues[index] }

    func didSelectLeague(at index: Int) {
        guard isConnected() else {
            view?.showError("No internet connection. Please check your network and try again.")
            return
        }
        guard let navigationController = navigationController else { return }
        guard let key = leagues[index].leagueKey else { return }
        guard let favorite = favorites.first(where: { $0.leagueKey == key }) else { return }
        router.showLeagueDetails(league: leagues[index], sport: favorite.sportType, navigationController: navigationController)
    }

    func toggleFavorite(at index: Int) {
        guard let key = leagues[index].leagueKey else { return }
        try? database.delete(by: key)
        leagues.remove(at: index)
        favorites.removeAll { $0.leagueKey == key }
        view?.showEmptyState(leagues.isEmpty)
        view?.showLeagues(leagues)
    }

    func isFavorite(at index: Int) -> Bool { return true }

    func updateFavoriteButton(at index: Int, isFavorite: Bool) {}

    private func isConnected() -> Bool {
        let monitor = NWPathMonitor()
        var connected = false
        let semaphore = DispatchSemaphore(value: 0)
        monitor.pathUpdateHandler = { path in
            connected = path.status == .satisfied
            semaphore.signal()
            monitor.cancel()
        }
        monitor.start(queue: DispatchQueue.global())
        semaphore.wait()
        return connected
    }
}

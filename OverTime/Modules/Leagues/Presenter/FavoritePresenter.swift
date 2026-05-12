import Foundation

class FavoritesPresenter: LeaguePresenterProtocol {

    private weak var view: LeagueView?
    private let router: AppRouterProtocol
    private let database: DatabaseManagerProtocol
    private var leagues: [League] = []

    init(router: AppRouterProtocol, database: DatabaseManagerProtocol = DatabaseManager()) {
        self.router = router
        self.database = database
    }

    func attachView(_ view: LeagueView) {
        self.view = view
    }

    func loadLeagues() {
        do {
            let favorites = try database.fetchAllLeagues()
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
        } catch {
            view?.showError(error.localizedDescription)
        }
    }

    func leaguesCount() -> Int {
        return leagues.count
    }

    func getLeague(at index: Int) -> League {
        return leagues[index]
    }

    func didSelectLeague(at index: Int) {
        guard let key = leagues[index].leagueKey else { return }
        guard let favorite = try? database.fetchAllLeagues().first(where: { $0.leagueKey == key }) else { return }
        router.showLeagueDetails(league: leagues[index], sport: favorite.sportType)
    }

    func toggleFavorite(at index: Int) {
        guard let key = leagues[index].leagueKey else { return }
        try? database.delete(by: key)
        leagues.remove(at: index)
        view?.showLeagues(leagues)
    }

    func isFavorite(at index: Int) -> Bool {
        return true
    }
}

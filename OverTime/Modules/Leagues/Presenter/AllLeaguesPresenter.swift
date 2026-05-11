import Foundation

class AllLeaguesPresenter: LeaguePresenterProtocol {

    private weak var view: LeagueView?
    private let router: AppRouterProtocol
    private let sport: SportType
    private var leagues: [League] = []
    private var favorites: Set<Int> = []

    init(router: AppRouterProtocol, sport: SportType) {
        self.router = router
        self.sport = sport
    }

    func attachView(_ view: LeagueView) {
        self.view = view
    }

    func loadLeagues() {
        SportsAPIManager.shared.fetchLeagues(sport: sport) { [weak self] result in
            DispatchQueue.main.async {
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

    func leaguesCount() -> Int {
        return leagues.count
    }

    func getLeague(at index: Int) -> League {
        return leagues[index]
    }

    func didSelectLeague(at index: Int) {
        let league = leagues[index]
        router.showLeagueDetails(league: league, sport: sport)
    }

    func toggleFavorite(at index: Int) {
        let key = leagues[index].leagueKey ?? -1
        if favorites.contains(key) {
            favorites.remove(key)
        } else {
            favorites.insert(key)
        }
    }

    func isFavorite(at index: Int) -> Bool {
        let key = leagues[index].leagueKey ?? -1
        return favorites.contains(key)
    }
}

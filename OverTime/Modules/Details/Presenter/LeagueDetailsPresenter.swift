import Foundation
import UIKit

class LeagueDetailsPresenter: DetailsPresenterProtocol {

    private weak var view: DetailsView?
    private let router: AppRouterProtocol
    private let league: League
    private let sport: SportType
    private let database: DatabaseManagerProtocol

    private var upcomingFixtures: [Fixture] = []
    private var latestFixtures: [Fixture] = []
    private var teams: [Team] = []
    private weak var navigationController: UINavigationController?


    private let dispatchGroup = DispatchGroup()

    init(router: AppRouterProtocol, league: League, sport: SportType, database: DatabaseManagerProtocol = DatabaseManager()) {
        self.router = router
        self.league = league
        self.sport = sport
        self.database = database
    }

    func attachView(_ view: DetailsView) {
        self.view = view
        self.navigationController = (view as? UIViewController)?.navigationController

    }

    func viewDidLoad() {
        view?.showLoading()
        view?.setTitle(league.leagueName ?? "League")
        view?.setFavoriteState(isFavorite())
        fetchAll()
    }

    private func fetchAll() {
        guard let leagueId = league.leagueKey else { return }

        dispatchGroup.enter()
        SportsAPIManager.shared.fetchUpcomingFixtures(sport: sport, leagueId: leagueId) { [weak self] result in
            if case .success(let fixtures) = result { self?.upcomingFixtures = fixtures }
            self?.dispatchGroup.leave()
        }

        dispatchGroup.enter()
        SportsAPIManager.shared.fetchLatestFixtures(sport: sport, leagueId: leagueId) { [weak self] result in
            if case .success(let fixtures) = result {
                self?.latestFixtures = fixtures.filter {
         	           let result = $0.eventFinalResult ?? ""
                    return !result.isEmpty && result != "? : ?"
                }
            }
            self?.dispatchGroup.leave()
        }

        dispatchGroup.enter()
        SportsAPIManager.shared.fetchTeams(sport: sport, leagueId: leagueId) { [weak self] result in
            if case .success(let teams) = result { self?.teams = teams }
            self?.dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.view?.hideLoading()
            self?.view?.reloadData()
        }
    }

    func numberOfSections() -> Int { return 3 }

    func numberOfItems(in section: Int) -> Int {
        switch section {
        case 0: return upcomingFixtures.count
        case 1: return latestFixtures.count
        case 2: return teams.count
        default: return 0
        }
    }

    func sectionTitle(for section: Int) -> String {
        switch section {
        case 0: return "Upcoming Fixtures"
        case 1: return "Latest Results"
        case 2: return "Teams"
        default: return ""
        }
    }

    func getUpcomingFixture(at index: Int) -> Fixture { return upcomingFixtures[index] }
    func getLatestFixture(at index: Int) -> Fixture { return latestFixtures[index] }
    func getTeam(at index: Int) -> Team { return teams[index] }

    func toggleFavorite() {
        guard let key = league.leagueKey else { return }
        if database.isLeagueFavorite(with: key) {
            try? database.delete(by: key)
            view?.setFavoriteState(false)
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
            view?.setFavoriteState(true)
        }
    }

    func isFavorite() -> Bool {
        guard let key = league.leagueKey else { return false }
        return database.isLeagueFavorite(with: key)
    }

    func didSelectTeam(at index: Int){
        guard let navigationController = navigationController else {return}
        let team = teams[index]
        router.showTeamDetails(team: team, sport: sport )
    }
    
    func isFavoriteSupported() -> Bool { return true }
    
}

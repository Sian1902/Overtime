import Foundation

final class TeamDetailsPresenter: DetailsPresenterProtocol {

    private weak var view: DetailsView?
    private let router: AppRouterProtocol
    private let apiManager: SportsAPIProtocol
    private let team: Team
    private let sport: SportType
    private var upcomingFixtures: [Fixture] = []
    private var latestFixtures: [Fixture] = []
    private var completedRequests = 0

    init(router: AppRouterProtocol,
         apiManager: SportsAPIProtocol,
         team: Team,
         sport: SportType) {
        self.router = router
        self.apiManager = apiManager
        self.team = team
        self.sport = sport
    }

    func attachView(_ view: DetailsView) {
        self.view = view
    }

    func viewDidLoad() {
        view?.setTitle(team.teamName ?? "Team")
        view?.setFavoriteState(false)
        fetchFixtures()
    }

    private func fetchFixtures() {
        view?.showLoading()
        completedRequests = 0

        apiManager.fetchUpcomingFixturesForTeam(sport: sport, teamId: team.teamKey ?? 0) { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let fixtures) = result { self?.upcomingFixtures = fixtures }
                if case .failure(let error) = result { self?.view?.showError(message: error.localizedDescription) }
                self?.requestDidComplete()
            }
        }

        apiManager.fetchLatestFixturesForTeam(sport: sport, teamId: team.teamKey ?? 0) { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let fixtures) = result { self?.latestFixtures = fixtures }
                if case .failure(let error) = result { self?.view?.showError(message: error.localizedDescription) }
                self?.requestDidComplete()
            }
        }
    }

    private func requestDidComplete() {
        completedRequests += 1
        if completedRequests == 2 {
            view?.hideLoading()
            view?.reloadData()
        }
    }

    func numberOfSections() -> Int { return 2 }

    func numberOfItems(in section: Int) -> Int {
        switch section {
        case 0: return upcomingFixtures.count
        case 1: return latestFixtures.count
        default: return 0
        }
    }

    func sectionTitle(for section: Int) -> String {
        switch section {
        case 0: return "Upcoming Fixtures"
        case 1: return "Latest Results"
        default: return ""
        }
    }

    func getUpcomingFixture(at index: Int) -> Fixture { upcomingFixtures[index] }
    func getLatestFixture(at index: Int) -> Fixture { latestFixtures[index] }
    func getTeam(at index: Int) -> Team { team }

    func toggleFavorite() {}
    func isFavorite() -> Bool { return false }
}

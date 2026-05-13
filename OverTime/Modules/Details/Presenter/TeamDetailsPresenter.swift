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
    private let dispatchGroup = DispatchGroup()

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
        guard let teamId = team.teamKey else { return }

                dispatchGroup.enter()
                apiManager.fetchUpcomingFixturesForTeam(sport: sport, teamId: teamId) { [weak self] result in
                    if case .success(let fixtures) = result {
                        self?.upcomingFixtures = fixtures
                    }
                    self?.dispatchGroup.leave()
                }

                dispatchGroup.enter()
                apiManager.fetchLatestFixturesForTeam(sport: sport, teamId: teamId) { [weak self] result in
                    if case .success(let fixtures) = result {
                        self?.latestFixtures = fixtures
                    }
                    self?.dispatchGroup.leave()
                }

                dispatchGroup.notify(queue: .main) { [weak self] in
                    self?.view?.hideLoading()
                    self?.view?.reloadData()
                    
                    if (self?.upcomingFixtures.isEmpty ?? true) && (self?.latestFixtures.isEmpty ?? true) {
                         self?.view?.showError(message: "No data available for this team")
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
    
    func didSelectTeam(at index: Int) {
        
    }
    func isFavoriteSupported() -> Bool { return false }
}

//
//  TeamDetailsPresenter.swift
//  OverTime
//
//  Created by Mona Zarea on 11/05/2026.
//

// Scenes/TeamDetails/TeamDetailsPresenter.swift
import Foundation

final class TeamDetailsPresenter: DetailsPresenterProtocol {

    private weak var view: DetailsView?
    private let router: AppRouterProtocol
    private let apiManager: SportsAPIProtocol
    private let team: Team
    private let sport: SportType

    private var upcomingFixtures: [Fixture] = []
    private var latestFixtures: [Fixture]   = []

    private var completedRequests = 0

    init(router: AppRouterProtocol,
         apiManager: SportsAPIProtocol,
         team: Team,
         sport: SportType) {
        self.router     = router
        self.apiManager = apiManager
        self.team       = team
        self.sport      = sport
    }

    func attachView(_ view: DetailsView) {
        self.view = view
    }

    func viewDidLoad() {
        view?.displayTeamDetails(team: team)    
        fetchFixtures()
    }


    private func fetchFixtures() {
        view?.showLoading()
        completedRequests = 0

        fetchUpcoming()
        fetchLatest()
    }

    private func fetchUpcoming() {
        apiManager.fetchUpcomingFixturesForTeam(
            sport: sport,
            teamId: team.teamKey ?? 0
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fixtures):
                    self?.upcomingFixtures = fixtures
                    self?.view?.displayUpcomingFixtures(fixtures: fixtures)
                case .failure(let error):
                    self?.view?.showError(message: error.localizedDescription)
                }
                self?.requestDidComplete()
            }
        }
    }

    private func fetchLatest() {
        apiManager.fetchLatestFixturesForTeam(
            sport: sport,
            teamId: team.teamKey ?? 0
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fixtures):
                    self?.latestFixtures = fixtures
                    self?.view?.displayLatestFixtures(fixtures: fixtures)
                case .failure(let error):
                    self?.view?.showError(message: error.localizedDescription)
                }
                self?.requestDidComplete()
            }
        }
    }

    private func requestDidComplete() {
        completedRequests += 1
        if completedRequests == 2 {
            view?.hideLoading()             
        }
    }

    
    func numberOfUpcomingItems() -> Int { upcomingFixtures.count }
    func numberOfLatestItems() -> Int   { latestFixtures.count   }

    func getUpcomingFixture(at index: Int) -> Fixture { upcomingFixtures[index] }
    func getLatestFixture(at index: Int) -> Fixture   { latestFixtures[index]   }
}

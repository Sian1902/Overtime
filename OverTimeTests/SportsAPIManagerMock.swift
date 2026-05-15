
import Foundation
@testable import OverTime

final class SportsAPIManagerMock: SportsAPIProtocol {


    var leaguesResult: Result<[League], NetworkError> = .success([])
    var upcomingFixturesResult: Result<[Fixture], NetworkError> = .success([])
    var latestFixturesResult: Result<[Fixture], NetworkError> = .success([])
    var teamsResult: Result<[Team], NetworkError> = .success([])
    var upcomingFixturesForTeamResult: Result<[Fixture], NetworkError> = .success([])
    var latestFixturesForTeamResult: Result<[Fixture], NetworkError> = .success([])


    private(set) var fetchLeaguesCallCount = 0
    private(set) var fetchUpcomingFixturesCallCount = 0
    private(set) var fetchLatestFixturesCallCount = 0
    private(set) var fetchTeamsCallCount = 0
    private(set) var fetchUpcomingFixturesForTeamCallCount = 0
    private(set) var fetchLatestFixturesForTeamCallCount = 0


    func fetchLeagues(sport: SportType,
                      completion: @escaping (Result<[League], NetworkError>) -> Void) {
        fetchLeaguesCallCount += 1
        completion(leaguesResult)
    }

    func fetchUpcomingFixtures(sport: SportType,
                               leagueId: Int,
                               completion: @escaping (Result<[Fixture], NetworkError>) -> Void) {
        fetchUpcomingFixturesCallCount += 1
        completion(upcomingFixturesResult)
    }

    func fetchLatestFixtures(sport: SportType,
                             leagueId: Int,
                             completion: @escaping (Result<[Fixture], NetworkError>) -> Void) {
        fetchLatestFixturesCallCount += 1
        completion(latestFixturesResult)
    }

    func fetchTeams(sport: SportType,
                    leagueId: Int,
                    completion: @escaping (Result<[Team], NetworkError>) -> Void) {
        fetchTeamsCallCount += 1
        completion(teamsResult)
    }

    func fetchUpcomingFixturesForTeam(sport: SportType,
                                      teamId: Int,
                                      completion: @escaping (Result<[Fixture], NetworkError>) -> Void) {
        fetchUpcomingFixturesForTeamCallCount += 1
        completion(upcomingFixturesForTeamResult)
    }

    func fetchLatestFixturesForTeam(sport: SportType,
                                    teamId: Int,
                                    completion: @escaping (Result<[Fixture], NetworkError>) -> Void) {
        fetchLatestFixturesForTeamCallCount += 1
        completion(latestFixturesForTeamResult)
    }
}

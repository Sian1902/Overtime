import Foundation

protocol SportsAPIProtocol {
    func fetchLeagues(sport: SportType, completion: @escaping (Result<[League], NetworkError>) -> Void)
    func fetchUpcomingFixtures(sport: SportType, leagueId: Int, completion: @escaping (Result<[Fixture], NetworkError>) -> Void)
    func fetchLatestFixtures(sport: SportType, leagueId: Int, completion: @escaping (Result<[Fixture], NetworkError>) -> Void)
    func fetchTeams(sport: SportType, leagueId: Int, completion: @escaping (Result<[Team], NetworkError>) -> Void)
    func fetchUpcomingFixturesForTeam(sport: SportType, teamId: Int, completion: @escaping (Result<[Fixture], NetworkError>) -> Void)
    func fetchLatestFixturesForTeam(sport: SportType, teamId: Int, completion: @escaping (Result<[Fixture], NetworkError>) -> Void)
}

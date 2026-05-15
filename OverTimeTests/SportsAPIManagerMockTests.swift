
import XCTest
@testable import OverTime

final class SportsAPIManagerMockTests: XCTestCase {


    private func makeLeague(key: Int = 1, name: String = "Premier League") -> League {
        League(
            leagueKey: key,
            leagueName: name,
            leagueYear: "2024",
            leagueSeason: "2024/2025",
            leagueLogo: nil,
            countryLogo: nil,
            countryKey: 41,
            countryName: "England",
            leagueBadge: nil
        )
    }

    private func makeFixture(key: Int = 1,
                             date: String = "2025-06-01",
                             home: String = "Arsenal",
                             away: String = "Chelsea") -> Fixture {
        Fixture(
            eventKey: key,
            eventDate: date,
            eventTime: "20:00",
            eventHomeTeam: home,
            homeTeamKey: 1,
            eventAwayTeam: away,
            awayTeamKey: 2,
            eventFinalResult: nil,
            eventStatus: nil,
            leagueName: "Premier League",
            leagueKey: 1,
            leagueSeason: "2024/2025",
            leagueLogo: nil,
            homeTeamLogo: nil,
            awayTeamLogo: nil,
            countryName: "England",
            eventLive: "0"
        )
    }

    private func makeTeam(key: Int = 1, name: String = "Arsenal") -> Team {
        Team(
            teamKey: key,
            teamName: name,
            teamBadge: nil,
            teamCountry: "England",
            teamFounded: "1886",
            teamDescription: nil,
            teamStadium: "Emirates",
            //coachName: nil,
            venue: nil
        )
    }


    func test_fetchLeagues_returnsStubbedLeagues() {
        let mock = SportsAPIManagerMock()
        let expected = [makeLeague(key: 1, name: "Premier League"),
                        makeLeague(key: 2, name: "La Liga")]
        mock.leaguesResult = .success(expected)

        var received: [League] = []
        mock.fetchLeagues(sport: .football) { result in
            if case .success(let leagues) = result { received = leagues }
        }

        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[0].leagueName, "Premier League")
        XCTAssertEqual(received[1].leagueName, "La Liga")
        XCTAssertEqual(mock.fetchLeaguesCallCount, 1)
    }

    func test_fetchLeagues_returnsFailure() {
        let mock = SportsAPIManagerMock()
        mock.leaguesResult = .failure(.apiFailure)

        var receivedError: NetworkError?
        mock.fetchLeagues(sport: .football) { result in
            if case .failure(let error) = result { receivedError = error }
        }

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(mock.fetchLeaguesCallCount, 1)
    }


    func test_fetchUpcomingFixtures_returnsStubbedFixtures() {
        let mock = SportsAPIManagerMock()
        let expected = [makeFixture(key: 1), makeFixture(key: 2)]
        mock.upcomingFixturesResult = .success(expected)

        var received: [Fixture] = []
        mock.fetchUpcomingFixtures(sport: .football, leagueId: 152) { result in
            if case .success(let fixtures) = result { received = fixtures }
        }

        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(mock.fetchUpcomingFixturesCallCount, 1)
    }

    func test_fetchUpcomingFixtures_returnsEmptyOnNoData() {
        let mock = SportsAPIManagerMock()
        mock.upcomingFixturesResult = .failure(.noData)

        var receivedError: NetworkError?
        mock.fetchUpcomingFixtures(sport: .football, leagueId: 152) { result in
            if case .failure(let error) = result { receivedError = error }
        }

        XCTAssertNotNil(receivedError)
    }


    func test_fetchLatestFixtures_returnsStubbedFixtures() {
        let mock = SportsAPIManagerMock()
        let expected = [makeFixture(key: 10, date: "2025-01-10")]
        mock.latestFixturesResult = .success(expected)

        var received: [Fixture] = []
        mock.fetchLatestFixtures(sport: .football, leagueId: 152) { result in
            if case .success(let fixtures) = result { received = fixtures }
        }

        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].eventDate, "2025-01-10")
        XCTAssertEqual(mock.fetchLatestFixturesCallCount, 1)
    }


    func test_fetchTeams_returnsStubbedTeams() {
        let mock = SportsAPIManagerMock()
        let expected = [makeTeam(key: 1, name: "Arsenal"),
                        makeTeam(key: 2, name: "Chelsea")]
        mock.teamsResult = .success(expected)

        var received: [Team] = []
        mock.fetchTeams(sport: .football, leagueId: 152) { result in
            if case .success(let teams) = result { received = teams }
        }

        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[0].teamName, "Arsenal")
        XCTAssertEqual(mock.fetchTeamsCallCount, 1)
    }

    func test_fetchTeams_tracksMultipleCalls() {
        let mock = SportsAPIManagerMock()
        mock.teamsResult = .success([makeTeam()])

        mock.fetchTeams(sport: .football, leagueId: 1) { _ in }
        mock.fetchTeams(sport: .basketball, leagueId: 2) { _ in }
        mock.fetchTeams(sport: .cricket, leagueId: 3) { _ in }

        XCTAssertEqual(mock.fetchTeamsCallCount, 3)
    }


    func test_fetchUpcomingFixturesForTeam_returnsStubbed() {
        let mock = SportsAPIManagerMock()
        let expected = [makeFixture(key: 5, home: "Arsenal", away: "Liverpool")]
        mock.upcomingFixturesForTeamResult = .success(expected)

        var received: [Fixture] = []
        mock.fetchUpcomingFixturesForTeam(sport: .football, teamId: 1) { result in
            if case .success(let fixtures) = result { received = fixtures }
        }

        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].eventHomeTeam, "Arsenal")
        XCTAssertEqual(mock.fetchUpcomingFixturesForTeamCallCount, 1)
    }

    func test_fetchLatestFixturesForTeam_returnsStubbed() {
        let mock = SportsAPIManagerMock()
        let expected = [makeFixture(key: 9, home: "Chelsea", away: "Man City")]
        mock.latestFixturesForTeamResult = .success(expected)

        var received: [Fixture] = []
        mock.fetchLatestFixturesForTeam(sport: .football, teamId: 2) { result in
            if case .success(let fixtures) = result { received = fixtures }
        }

        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received[0].eventAwayTeam, "Man City")
        XCTAssertEqual(mock.fetchLatestFixturesForTeamCallCount, 1)
    }


    func test_callCounts_areIndependent() {
        let mock = SportsAPIManagerMock()

        mock.fetchLeagues(sport: .football) { _ in }
        mock.fetchLeagues(sport: .basketball) { _ in }
        mock.fetchTeams(sport: .football, leagueId: 1) { _ in }

        XCTAssertEqual(mock.fetchLeaguesCallCount, 2)
        XCTAssertEqual(mock.fetchTeamsCallCount, 1)
        XCTAssertEqual(mock.fetchUpcomingFixturesCallCount, 0)
        XCTAssertEqual(mock.fetchLatestFixturesCallCount, 0)
    }
}

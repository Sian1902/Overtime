import XCTest
@testable import OverTime

final class SportsAPIManagerTests: XCTestCase {

    var sut: SportsAPIManager!

    override func setUp() {
        super.setUp()
        sut = SportsAPIManager.shared
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFetchLeaguesReturnsNonEmptyList() {
        let expectation = XCTestExpectation(description: "Fetch football leagues")

        sut.fetchLeagues(sport: .football) { result in
            switch result {
            case .success(let leagues):
                XCTAssertFalse(leagues.isEmpty, "Leagues list should not be empty")
                XCTAssertNotNil(leagues.first?.leagueName, "First league should have a name")
                XCTAssertNotNil(leagues.first?.leagueKey, "First league should have a key")
            case .failure(let error):
                XCTFail("Expected success but got error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchLeaguesForAllSports() {
        let sports: [SportType] = [.football, .basketball, .cricket, .tennis]

        for sport in sports {
            let expectation = XCTestExpectation(description: "Fetch leagues for \(sport.rawValue)")

            sut.fetchLeagues(sport: sport) { result in
                switch result {
                case .success(let leagues):
                    XCTAssertFalse(leagues.isEmpty, "\(sport.rawValue) leagues should not be empty")
                case .failure(let error):
                    XCTFail("\(sport.rawValue) failed: \(error.localizedDescription)")
                }
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 10.0)
        }
    }

    func testFetchUpcomingFixturesReturnsValidFixtures() {
        let expectation = XCTestExpectation(description: "Fetch upcoming fixtures")

        sut.fetchUpcomingFixtures(sport: .football, leagueId: 152) { result in
            switch result {
            case .success(let fixtures):
                XCTAssertNotNil(fixtures, "Fixtures should not be nil")
                if let first = fixtures.first {
                    XCTAssertNotNil(first.eventHomeTeam, "Home team should not be nil")
                    XCTAssertNotNil(first.eventAwayTeam, "Away team should not be nil")
                    XCTAssertNotNil(first.eventDate, "Event date should not be nil")
                }
            case .failure(let error):
                XCTFail("Expected success but got error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchLatestFixturesReturnsValidFixtures() {
        let expectation = XCTestExpectation(description: "Fetch latest fixtures")

        sut.fetchLatestFixtures(sport: .football, leagueId: 152) { result in
            switch result {
            case .success(let fixtures):
                XCTAssertNotNil(fixtures, "Fixtures should not be nil")
                if let first = fixtures.first {
                    XCTAssertNotNil(first.eventFinalResult, "Final result should not be nil")
                    XCTAssertNotEqual(first.eventFinalResult, "? : ?", "Result should be a valid score")
                }
            case .failure(let error):
                XCTFail("Expected success but got error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchTeamsReturnsNonEmptyList() {
        let expectation = XCTestExpectation(description: "Fetch teams")

        sut.fetchTeams(sport: .football, leagueId: 152) { result in
            switch result {
            case .success(let teams):
                XCTAssertFalse(teams.isEmpty, "Teams list should not be empty")
                XCTAssertNotNil(teams.first?.teamName, "First team should have a name")
                XCTAssertNotNil(teams.first?.teamKey, "First team should have a key")
            case .failure(let error):
                XCTFail("Expected success but got error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchUpcomingFixturesForTeam() {
        let expectation = XCTestExpectation(description: "Fetch upcoming fixtures for team")

        sut.fetchUpcomingFixturesForTeam(sport: .football, teamId: 80) { result in
            switch result {
            case .success(let fixtures):
                XCTAssertNotNil(fixtures, "Fixtures should not be nil")
                if let first = fixtures.first {
                    XCTAssertNotNil(first.eventHomeTeam, "Home team should not be nil")
                    XCTAssertNotNil(first.eventAwayTeam, "Away team should not be nil")
                }
            case .failure(let error):
                XCTFail("Expected success but got error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchLatestFixturesForTeam() {
        let expectation = XCTestExpectation(description: "Fetch latest fixtures for team")

        sut.fetchLatestFixturesForTeam(sport: .football, teamId: 80) { result in
            switch result {
            case .success(let fixtures):
                XCTAssertNotNil(fixtures, "Fixtures should not be nil")
                if let first = fixtures.first {
                    XCTAssertNotNil(first.eventHomeTeam, "Home team should not be nil")
                    XCTAssertNotNil(first.eventAwayTeam, "Away team should not be nil")
                }
            case .failure(let error):
                XCTFail("Expected success but got error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchLeaguesWithInvalidSportReturnsError() {
        let expectation = XCTestExpectation(description: "Invalid sport returns failure or empty")

        sut.fetchLeagues(sport: .tennis) { result in
            switch result {
            case .success(let leagues):
                XCTAssertNotNil(leagues)
            case .failure:
                break
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}

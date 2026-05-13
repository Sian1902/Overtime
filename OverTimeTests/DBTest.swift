import XCTest
import CoreData
@testable import OverTime

final class DatabaseManagerTests: XCTestCase {

    var sut: DatabaseManager!

    let sampleLeague = FavoriteLeague(
        leagueKey: 152,
        leagueName: "Premier League",
        leagueYear: "2024",
        leagueSeason: "2024/2025",
        leagueLogo: "https://logo.jpg",
        countryLogo: "https://country.jpg",
        countryKey: 41,
        countryName: "England",
        leagueBadge: "https://badge.jpg",
        sportType: .football
    )

    override func setUp() {
        super.setUp()
        sut = DatabaseManager(containerName: "OverTime", inMemory: true)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSaveLeagueSucceeds() throws {
        try sut.save(league: sampleLeague)
        let results = try sut.fetchAllLeagues()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.leagueName, "Premier League")
    }

    func testSaveDuplicateLeagueIsIgnored() throws {
        try sut.save(league: sampleLeague)
        try sut.save(league: sampleLeague)
        let results = try sut.fetchAllLeagues()
        XCTAssertEqual(results.count, 1)
    }

    func testFetchAllLeaguesReturnsEmpty() throws {
        let results = try sut.fetchAllLeagues()
        XCTAssertTrue(results.isEmpty)
    }

    func testFetchAllLeaguesReturnsSavedData() throws {
        try sut.save(league: sampleLeague)
        let results = try sut.fetchAllLeagues()
        XCTAssertEqual(results.first?.leagueKey, 152)
        XCTAssertEqual(results.first?.leagueSeason, "2024/2025")
        XCTAssertEqual(results.first?.sportType, .football)
    }

    func testDeleteLeagueSucceeds() throws {
        try sut.save(league: sampleLeague)
        try sut.delete(by: 152)
        let results = try sut.fetchAllLeagues()
        XCTAssertTrue(results.isEmpty)
    }

    func testDeleteNonExistentLeagueDoesNotThrow() {
        XCTAssertNoThrow(try sut.delete(by: 999))
    }

    func testIsLeagueFavoriteReturnsTrueAfterSave() throws {
        try sut.save(league: sampleLeague)
        XCTAssertTrue(sut.isLeagueFavorite(with: 152))
    }

    func testIsLeagueFavoriteReturnsFalseWhenNotSaved() {
        XCTAssertFalse(sut.isLeagueFavorite(with: 999))
    }

    func testIsLeagueFavoriteReturnsFalseAfterDelete() throws {
        try sut.save(league: sampleLeague)
        try sut.delete(by: 152)
        XCTAssertFalse(sut.isLeagueFavorite(with: 152))
    }

    func testSaveMultipleLeagues() throws {
        let league2 = FavoriteLeague(
            leagueKey: 207,
            leagueName: "La Liga",
            leagueYear: "2024",
            leagueSeason: "2024/2025",
            leagueLogo: "https://laliga.jpg",
            countryLogo: "",
            countryKey: 6,
            countryName: "Spain",
            leagueBadge: "https://laliga-badge.jpg",
            sportType: .football
        )

        try sut.save(league: sampleLeague)
        try sut.save(league: league2)

        let results = try sut.fetchAllLeagues()
        XCTAssertEqual(results.count, 2)
    }

    func testDeleteOneOfMultipleLeagues() throws {
        let league2 = FavoriteLeague(
            leagueKey: 207,
            leagueName: "La Liga",
            leagueYear: "2024",
            leagueSeason: "2024/2025",
            leagueLogo: "https://laliga.jpg",
            countryLogo: "",
            countryKey: 6,
            countryName: "Spain",
            leagueBadge: "https://laliga-badge.jpg",
            sportType: .football
        )

        try sut.save(league: sampleLeague)
        try sut.save(league: league2)
        try sut.delete(by: 152)

        let results = try sut.fetchAllLeagues()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.leagueName, "La Liga")
    }
}

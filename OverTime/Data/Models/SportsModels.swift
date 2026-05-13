import Foundation

enum SportType: String {
    case football = "football"
    case basketball = "basketball"
    case cricket = "cricket"
    case tennis = "tennis"
    case baseball = "baseball"
}

struct APIResponse<T: Decodable>: Decodable {
    let success: Int
    let result: T?
}

struct League: Decodable {
    let leagueKey: Int?
    let leagueName: String?
    let leagueYear: String?
    let leagueSeason: String?
    let leagueLogo: String?
    let countryLogo: String?
    let countryKey: Int?
    let countryName: String?
    let leagueBadge: String?

    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case leagueYear = "league_year"
        case leagueSeason = "league_season"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
        case countryKey = "country_key"
        case countryName = "country_name"
        case leagueBadge = "strBadge"
    }
}

struct Fixture: Decodable {
    let eventKey: Int?
    let eventDate: String?
    let eventTime: String?
    let eventHomeTeam: String?
    let homeTeamKey: Int?
    let eventAwayTeam: String?
    let awayTeamKey: Int?
    let eventFinalResult: String?
    let eventStatus: String?
    let leagueName: String?
    let leagueKey: Int?
    let leagueSeason: String?
    let leagueLogo: String?
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    let countryName: String?
    let eventLive: String?

    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case homeTeamKey = "home_team_key"
        case eventAwayTeam = "event_away_team"
        case awayTeamKey = "away_team_key"
        case eventFinalResult = "event_final_result"
        case eventStatus = "event_status"
        case leagueName = "league_name"
        case leagueKey = "league_key"
        case leagueSeason = "league_season"
        case leagueLogo = "league_logo"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case countryName = "country_name"
        case eventLive = "event_live"
    }
}

struct Team: Decodable {
    let teamKey: Int?
    let teamName: String?
    let teamBadge: String?
    let teamCountry: String?
    let teamFounded: String?
    let teamDescription: String?
    let teamStadium: String?
    let venue: String?

    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamBadge = "team_logo"
        case teamCountry = "team_country"
        case teamFounded = "team_founded"
        case teamDescription = "team_description"
        case teamStadium = "team_stadium"
        case venue = "venue"
    }
}

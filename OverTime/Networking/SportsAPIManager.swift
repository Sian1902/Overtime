import Foundation
import Alamofire

class SportsAPIManager: SportsAPIProtocol {

    static let shared = SportsAPIManager()

    private init() {}

    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func todayString() -> String {
        return dateString(from: Date())
    }

    private func oneYearAgoString() -> String {
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        return dateString(from: oneYearAgo)
    }

    private func oneYearAheadString() -> String {
        let oneYearAhead = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
        return dateString(from: oneYearAhead)
    }

    private func request<T: Decodable>(
        url: String,
        parameters: Parameters,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        AF.request(url, parameters: parameters).validate().responseDecodable(of: APIResponse<T>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                guard apiResponse.success == 1, let result = apiResponse.result else {
                    completion(.failure(.apiFailure))
                    return
                }
                completion(.success(result))
            case .failure(let error):
                if let data = response.data,
                   let _ = try? JSONDecoder().decode(APIResponse<T>.self, from: data) {
                    completion(.failure(.noData))
                } else {
                    completion(.failure(.requestFailed(error)))
                }
            }
        }
    }

    func fetchLeagues(sport: SportType, completion: @escaping (Result<[League], NetworkError>) -> Void) {
        let url = NetworkConstants.sportURL(sport)
        let parameters: Parameters = [
            "met": "Leagues",
            "APIkey": NetworkConstants.apiKey
        ]
        request(url: url, parameters: parameters, completion: completion)
    }

    func fetchUpcomingFixtures(sport: SportType, leagueId: Int, completion: @escaping (Result<[Fixture], NetworkError>) -> Void) {
        let url = NetworkConstants.sportURL(sport)
        let parameters: Parameters = [
            "met": "Fixtures",
            "APIkey": NetworkConstants.apiKey,
            "leagueId": leagueId,
            "from": todayString(),
            "to": oneYearAheadString()
        ]
        request(url: url, parameters: parameters, completion: completion)
    }

    func fetchLatestFixtures(sport: SportType, leagueId: Int, completion: @escaping (Result<[Fixture], NetworkError>) -> Void) {
        let url = NetworkConstants.sportURL(sport)
        let parameters: Parameters = [
            "met": "Fixtures",
            "APIkey": NetworkConstants.apiKey,
            "leagueId": leagueId,
            "from": twoWeeksAgoString(),
            "to": todayString()
        ]
        request(url: url, parameters: parameters, completion: completion)
    }

    func fetchTeams(sport: SportType, leagueId: Int, completion: @escaping (Result<[Team], NetworkError>) -> Void) {
        let url = NetworkConstants.sportURL(sport)
        let parameters: Parameters = [
            "met": "Teams",
            "APIkey": NetworkConstants.apiKey,
            "leagueId": leagueId
        ]
        request(url: url, parameters: parameters, completion: completion)
    }
    
    private func twoWeeksAgoString() -> String {
        let twoWeeksAgo = Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()
        return dateString(from: twoWeeksAgo)
    }

    func fetchUpcomingFixturesForTeam(sport: SportType, teamId: Int, completion: @escaping (Result<[Fixture], NetworkError>) -> Void) {
        let url = NetworkConstants.sportURL(sport)
        let parameters: Parameters = [
            "met": "Fixtures",
            "APIkey": NetworkConstants.apiKey,
            "teamId": teamId,
            "from": todayString(),
            "to": oneYearAheadString()
        ]
        request(url: url, parameters: parameters, completion: completion)
    }

    func fetchLatestFixturesForTeam(sport: SportType, teamId: Int, completion: @escaping (Result<[Fixture], NetworkError>) -> Void) {
        let url = NetworkConstants.sportURL(sport)
        let parameters: Parameters = [
            "met": "Fixtures",
            "APIkey": NetworkConstants.apiKey,
            "teamId": teamId,
            "from": oneYearAgoString(),
            "to": todayString()
        ]
        request(url: url, parameters: parameters, completion: completion)
    }
}

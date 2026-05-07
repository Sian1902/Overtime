import Foundation

struct NetworkConstants {
    static let apiKey = Secret.apiKey
    static let baseURL = "https://apiv2.allsportsapi.com"

    static func sportURL(_ sport: SportType) -> String {
        return "\(baseURL)/\(sport.rawValue)/"
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingFailed(Error)
    case requestFailed(Error)
    case apiFailure

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data returned from server"
        case .decodingFailed(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .apiFailure:
            return "API returned failure status"
        }
    }
}

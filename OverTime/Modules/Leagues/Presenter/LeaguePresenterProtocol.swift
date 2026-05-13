import Foundation

protocol LeagueView: AnyObject {
    func showLeagues(_ leagues: [League])
    func showError(_ message: String)
    func updateFavoriteButton(at index: Int, isFavorite: Bool)
    func showEmptyState(_ isVisible: Bool)
}

protocol LeaguePresenterProtocol {
    func attachView(_ view: LeagueView)
    func loadLeagues()
    func leaguesCount() -> Int
    func getLeague(at index: Int) -> League
    func didSelectLeague(at index: Int)
    func toggleFavorite(at index: Int)
    func isFavorite(at index: Int) -> Bool
}

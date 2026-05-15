import Foundation
protocol DetailsView: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(message: String)
    func setTitle(_ title: String)
    func setFavoriteState(_ isFavorite: Bool)
    //func navigateToTeamDetails(team: Team, sport: SportType)

}

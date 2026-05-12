import Foundation

protocol DetailsPresenterProtocol: AnyObject {
    func attachView(_ view: DetailsView)
    func viewDidLoad()
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func sectionTitle(for section: Int) -> String
    func getUpcomingFixture(at index: Int) -> Fixture
    func getLatestFixture(at index: Int) -> Fixture
    func getTeam(at index: Int) -> Team
    func toggleFavorite()
    func isFavorite() -> Bool
    func didSelectTeam(at index: Int)
    func isFavoriteSupported() -> Bool
}

import UIKit
import Foundation

class SportsPresenter: SportsPresenterProtocol {

    private let sports: [Sport] = [
        Sport(name: "Basketball", imageName: "basketball"),
        Sport(name: "Football", imageName: "football"),
        Sport(name: "Tennis", imageName: "tennis"),
        Sport(name: "Cricket", imageName: "cricket")
    ]
    

    private let sportTypes: [SportType] = [
        .basketball,
        .football,
        .tennis,
        .cricket
    ]

    private weak var view: SportsView?
    private let router: AppRouterProtocol

    init(router: AppRouterProtocol) {
        self.router = router
    }

    func attachView(_ view: SportsView) {
        self.view = view
    }

    func didSelectedSport(at index: Int, navigationController: UINavigationController) {
        let sport = sportTypes[index]
        router.showLeagues(sport: sport, navigationController: navigationController)
    }

    func SportsNumber() -> Int {
        return sports.count
    }

    func getSport(at index: Int) -> Sport {
        return sports[index]
    }
}

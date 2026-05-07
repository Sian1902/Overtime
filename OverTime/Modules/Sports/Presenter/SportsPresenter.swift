import Foundation

class SportsPresenter: SportsPresenterProtocol {
    
    private let sports: [Sport] = [
        Sport(name: "Basketball", imageName: "basketball"),
        Sport(name: "Football", imageName: "football"),
        Sport(name: "Tennis", imageName: "tennis"),
        Sport(name: "American Football", imageName: "americanFootball"),
        Sport(name: "Baseball", imageName: "baseball"),
        Sport(name: "Hockey", imageName: "hockey"),
        Sport(name: "Cricket", imageName: "cricket")
    ]
    
    private weak var view: SportsView?
    private let router: AppRouterProtocol
    
    init(router: AppRouterProtocol) {
        self.router = router
    }
    
    func attachView(_ view: SportsView) {
        self.view = view
    }
    
    func didSelectedSport(at index: Int) {
        print("selected sport is \(sports[index].name)")
    }
    
    func SportsNumber() -> Int {
        return sports.count
    }
    
    func getSport(at index: Int) -> Sport {
        return sports[index]
    }
}

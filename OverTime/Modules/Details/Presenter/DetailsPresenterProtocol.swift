//
//  TeamDetailsPresenter.swift
//  OverTime
//
//  Created by Mona Zarea on 11/05/2026.
//

import Foundation
protocol DetailsPresenterProtocol: AnyObject {
    func attachView(_ view: DetailsView)
    func viewDidLoad()
    
    func numberOfUpcomingItems() -> Int
    func numberOfLatestItems() -> Int
    func getUpcomingFixture(at index: Int) -> Fixture
    func getLatestFixture(at index: Int) -> Fixture
    
}

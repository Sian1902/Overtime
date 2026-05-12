//
//  TeamView.swift
//  OverTime
//
//  Created by Mona Zarea on 11/05/2026.
//

import Foundation
protocol DetailsView: AnyObject {
    func showLoading()
    func hideLoading()
    func displayTeamDetails(team: Team)
    func displayUpcomingFixtures(fixtures: [Fixture])
    func displayLatestFixtures(fixtures: [Fixture])
    func showError(message: String)
}

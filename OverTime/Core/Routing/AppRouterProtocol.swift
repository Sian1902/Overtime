//
//  AppRouterProtocol.swift
//  OverTime
//
//  Created by Mona Zarea on 06/05/2026.
//
import UIKit
import Foundation

protocol AppRouterProtocol{
    func showSplash()
    func showOnboarding()
    //func showSportsScreen()
    func showMainTabBar()
    func showLeagues(sport: SportType, navigationController: UINavigationController)
    func showLeagueDetails(league: League, sport: SportType)
}

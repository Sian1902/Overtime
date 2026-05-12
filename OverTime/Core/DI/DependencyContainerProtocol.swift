//
//  DependencyContainerProtocol.swift
//  OverTime
//
//  Created by Mona Zarea on 06/05/2026.
//

import UIKit
protocol DependencyContainerProtocol {
    func makeSplashViewController(router: AppRouterProtocol) -> UIViewController
    func makeSportsViewController(router: AppRouterProtocol) -> UIViewController
    func makeFavoritesViewController(router: AppRouterProtocol) -> UIViewController
    func makeMainTabBarController(router: AppRouterProtocol) -> UIViewController
    func makeTeamDetailsViewController(router: AppRouterProtocol, team: Team, sport: SportType) -> UIViewController 
}

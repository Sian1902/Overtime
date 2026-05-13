//
//  TabBarConfigurator.swift
//  OverTime
//
//  Created by Mona Zarea on 09/05/2026.
//

import UIKit

class TabBarConfigurator{
    static func configure(
        tabBar: UITabBarController,
        sports: UIViewController,
        favorites: UIViewController
    ) -> UITabBarController{
        
        let sportsNav = UINavigationController(rootViewController: sports)
        let favoritesNav = UINavigationController(rootViewController: favorites)
        
        sportsNav.tabBarItem = UITabBarItem(
            title: "Sports",
            image: UIImage(systemName: "sportscourt"),
            selectedImage: UIImage(systemName: "sportscourt.fill")
        )

        favoritesNav.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        let appearance = UITabBarAppearance()
        
            
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .appBackground
        
//        appearance.shadowImage = nil
//        appearance.shadowColor = .appPrimary

        appearance.stackedLayoutAppearance.selected.iconColor = .appPrimary
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.appPrimary
        ]
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray
        ]

        tabBar.tabBar.standardAppearance = appearance
        tabBar.tabBar.scrollEdgeAppearance = appearance
        tabBar.viewControllers = [sportsNav, favoritesNav]

        return tabBar
    }
}

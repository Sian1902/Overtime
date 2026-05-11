//
//  FavoriteLeague.swift
//  OverTime
//
//  Created by Mona Zarea on 10/05/2026.
//

import Foundation

struct FavoriteLeague {
    let leagueKey: Int
    let leagueName: String
    let leagueYear: String
    let leagueSeason: String
    let leagueLogo: String
    let countryLogo: String
    let countryKey: Int
    let countryName: String
    let leagueBadge: String
    let sportType: SportType
}
extension FavoriteLeague {
    func toLeague() -> League{
        League(leagueKey: leagueKey, leagueName: leagueName, leagueYear: leagueYear, leagueSeason: leagueSeason, leagueLogo: leagueLogo, countryLogo: countryLogo, countryKey: countryKey, countryName: countryName, leagueBadge: leagueBadge)
    }
}

//
//  DatabaseManagerProtocol.swift
//  OverTime
//
//  Created by Mona Zarea on 10/05/2026.
//

import Foundation

protocol DatabaseManagerProtocol: AnyObject {
    func save(league: FavoriteLeague) throws
    func fetchAllLeagues() throws -> [FavoriteLeague]
    func delete(by leagueKey: Int) throws
    func isLeagueFavorite(with leagueKey: Int) -> Bool
}

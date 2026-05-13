//
//  DatabaseManager.swift
//  OverTime
//
//  Created by Mona Zarea on 10/05/2026.
//
import CoreData
class DatabaseManager : DatabaseManagerProtocol{
   
    
    private let persistentContainer : NSPersistentContainer
    
    init(containerName: String = "OverTime"){
        persistentContainer = NSPersistentContainer(name: containerName)
        persistentContainer.loadPersistentStores{ _ , error in
            if let _=error {fatalError("CoreData failed : \(error)")}
        }
    }
    private var context : NSManagedObjectContext{
        persistentContainer.viewContext
    }
    
    
    
    func save(league: FavoriteLeague) throws {
        guard !isLeagueFavorite(with: league.leagueKey) else {return}
        let entity = LeagueEntity(context: context)
        entity.leagueKey   = Int64(league.leagueKey)
        entity.leagueName  = league.leagueName
        entity.leagueLogo  = league.leagueLogo
        entity.leagueBadge = league.leagueBadge
        entity.countryName = league.countryName
        entity.countryLogo = league.countryLogo
        entity.leagueSeason = league.leagueSeason
        entity.countryKey = Int64(league.countryKey)
        entity.leagueYear = league.leagueYear
        entity.sportType   = league.sportType.rawValue
        
        try context.save()
    }
    
    func fetchAllLeagues() throws -> [FavoriteLeague] {
        let request = LeagueEntity.fetchRequest()
        let entities = try context.fetch(request)
        return entities.compactMap { $0.toFavoriteLeague()}
        
    }
    
    func delete(by leagueKey: Int) throws {
        let request = LeagueEntity.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %lld", leagueKey)
        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        try context.save()
    }
    
    
    
    func isLeagueFavorite(with leagueKey: Int) -> Bool {
        let request = LeagueEntity.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %lld", leagueKey)
        return (try? context.fetch(request).isEmpty == false) ?? false
    }
    
}
extension LeagueEntity {
    func toFavoriteLeague() -> FavoriteLeague?{
        guard let leagueName = self.leagueName,
            let leagueSeason = self.leagueSeason,
              let leagueLogo = self.leagueLogo,
              let rawSport = self.sportType,
              let sport = SportType(rawValue: rawSport)
        else{return nil}
              
        return FavoriteLeague(leagueKey: Int(self.leagueKey),
                              leagueName: leagueName,
                              leagueYear: self.leagueYear ?? "",
                              leagueSeason: leagueSeason,
                              leagueLogo: leagueLogo,
                              countryLogo: self.countryLogo ?? "",
                              countryKey: Int(self.countryKey ),
                              countryName: self.countryName ?? "",
                              leagueBadge: self.leagueBadge ?? "" ,
                              sportType: sport)
    }
}

//
//  UserDefaultManager.swift
//  OverTime
//
//  Created by Mona Zarea on 06/05/2026.
//

import Foundation
protocol UserDefaultsManagerProtocol{
    var hasSeenOnboarding: Bool{set get}
}
class UserDefaultManager : UserDefaultsManagerProtocol{
    private let defaults : UserDefaults
    
    init(defaults : UserDefaults = .standard){
        self.defaults = defaults
    }
    
    private enum Keys{
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }
    
    var hasSeenOnboarding: Bool{
        set{defaults.set(newValue,forKey: Keys.hasSeenOnboarding)}
        get{defaults.bool(forKey: Keys.hasSeenOnboarding)}
    }
}

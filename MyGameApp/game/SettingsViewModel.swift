import Foundation
import SwiftUI

struct GameStats {
    var matchesPlayed: Int
    var matchesWon: Int
    var matchesLost: Int
    var maxSpiritReached: Int
    var maxStrengthReached: Int
    var maxPopularityReached: Int
    var maxFatigueReached: Int
    var activitiesCompleted: Int
    var proPlayersBought: Int
    var legendPlayersBought: Int
}

class SettingsViewModel: ObservableObject {
    @Published var stats: GameStats
    @AppStorage("isVibroEnabled") var isVibroEnabled = true
    @AppStorage("isSoundEnabled") var isSoundEnabled = true
    
    private let gameState = GameState()
    
    init() {
        self.stats = GameStats(
            matchesPlayed: UserDefaults.standard.integer(forKey: "matchesPlayed"),
            matchesWon: UserDefaults.standard.integer(forKey: "matchesWon"),
            matchesLost: UserDefaults.standard.integer(forKey: "matchesLost"),
            maxSpiritReached: UserDefaults.standard.integer(forKey: "maxSpiritReached"),
            maxStrengthReached: UserDefaults.standard.integer(forKey: "maxStrengthReached"),
            maxPopularityReached: UserDefaults.standard.integer(forKey: "maxPopularityReached"),
            maxFatigueReached: UserDefaults.standard.integer(forKey: "maxFatigueReached"),
            activitiesCompleted: UserDefaults.standard.integer(forKey: "activitiesCompleted"),
            proPlayersBought: UserDefaults.standard.integer(forKey: "proPlayersBought"),
            legendPlayersBought: UserDefaults.standard.integer(forKey: "legendPlayersBought")
        )
        
        self.isVibroEnabled = UserDefaults.standard.bool(forKey: "isVibroEnabled")
        self.isSoundEnabled = UserDefaults.standard.bool(forKey: "isSoundEnabled")
        
        updateMaxStats()
    }
    
    func updateMaxStats() {
        let currentSpirit = Int(gameState.getStat(.teamSpirit) * 100)
        let currentStrength = Int(gameState.getStat(.strength) * 100)
        let currentPopularity = Int(gameState.getStat(.popularity) * 100)
        let currentFatigue = Int(gameState.getStat(.fatigue) * 100)
        
        if currentSpirit > stats.maxSpiritReached {
            stats.maxSpiritReached = currentSpirit
        }
        
        if currentStrength > stats.maxStrengthReached {
            stats.maxStrengthReached = currentStrength
        }
        
        if currentPopularity > stats.maxPopularityReached {
            stats.maxPopularityReached = currentPopularity
        }
        
        if currentFatigue > stats.maxFatigueReached {
            stats.maxFatigueReached = currentFatigue
        }
        
        saveStats()
    }
    
    func incrementMatchStats(won: Bool) {
        stats.matchesPlayed += 1
        if won {
            stats.matchesWon += 1
        } else {
            stats.matchesLost += 1
        }
        saveStats()
    }
    
    func incrementActivityCompleted() {
        stats.activitiesCompleted += 1
        saveStats()
    }
    
    func incrementPlayerBought(isLegend: Bool) {
        if isLegend {
            stats.legendPlayersBought += 1
        } else {
            stats.proPlayersBought += 1
        }
        saveStats()
    }
    
    func saveStats() {
        UserDefaults.standard.set(stats.matchesPlayed, forKey: "matchesPlayed")
        UserDefaults.standard.set(stats.matchesWon, forKey: "matchesWon")
        UserDefaults.standard.set(stats.matchesLost, forKey: "matchesLost")
        UserDefaults.standard.set(stats.maxSpiritReached, forKey: "maxSpiritReached")
        UserDefaults.standard.set(stats.maxStrengthReached, forKey: "maxStrengthReached")
        UserDefaults.standard.set(stats.maxPopularityReached, forKey: "maxPopularityReached")
        UserDefaults.standard.set(stats.maxFatigueReached, forKey: "maxFatigueReached")
        UserDefaults.standard.set(stats.activitiesCompleted, forKey: "activitiesCompleted")
        UserDefaults.standard.set(stats.proPlayersBought, forKey: "proPlayersBought")
        UserDefaults.standard.set(stats.legendPlayersBought, forKey: "legendPlayersBought")
    }
}

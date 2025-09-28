import Foundation
import SwiftUI

// MARK: - Shop Models

struct Booster: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let price: Int
    var isPurchased: Bool = false
    
    func apply(to gameState: GameState) {
        switch name {
        case "Energetic":
            gameState.updateStat(.fatigue, by: 10)
        case "Activity Booster":
            gameState.updateStat(.strength, by: 10)
        case "Equipment":
            gameState.updateStat(.teamSpirit, by: 10)
            gameState.updateStat(.popularity, by: 10)
        default:
            break
        }
    }
}

// MARK: - Shop View Model

class ShopViewModel: ObservableObject {
    @Published var boosters: [Booster] = [
        Booster(name: "Energetic", description: "+Fatigue", icon: "energetic", price: 20),
        Booster(name: "Activity Booster", description: "+Strength", icon: "activity", price: 20),
        Booster(name: "Equipment", description: "+Team Spirit, +Popularity", icon: "equipment", price: 40)
    ]
    
    @Published var proPlayers: [Player] = [
        Player(name: "Pro Goalkeeper", type: .pro, position: .goalkeeper, image: "proGoalkeeper", price: 20),
        Player(name: "Pro Defender Left", type: .pro, position: .defenderLeft, image: "proDefenderLeft", price: 20),
        Player(name: "Pro Defender Center", type: .pro, position: .defenderCenter, image: "proDefenderCenter", price: 20),
        Player(name: "Pro Defender Right", type: .pro, position: .defenderRight, image: "proDefenderRight", price: 20),
        Player(name: "Pro Forward Left", type: .pro, position: .forwardLeft, image: "proForwardLeft", price: 20),
        Player(name: "Pro Forward Right", type: .pro, position: .forwardRight, image: "proForwardRight", price: 20)
    ]
    
    @Published var legendPlayers: [Player] = [
        Player(name: "Legend Goalkeeper", type: .legend, position: .goalkeeper, image: "legendGoalkeeper", price: 40),
        Player(name: "Legend Defender Left", type: .legend, position: .defenderLeft, image: "legendDefenderLeft", price: 40),
        Player(name: "Legend Defender Center", type: .legend, position: .defenderCenter, image: "legendDefenderCenter", price: 40),
        Player(name: "Legend Defender Right", type: .legend, position: .defenderRight, image: "legendDefenderRight", price: 40),
        Player(name: "Legend Forward Left", type: .legend, position: .forwardLeft, image: "legendForwardLeft", price: 40),
        Player(name: "Legend Forward Right", type: .legend, position: .forwardRight, image: "legendForwardRight", price: 40)
    ]
    
    private var gameState: GameState?
    
    func updateGameState(_ gameState: GameState) {
        self.gameState = gameState
    }
    
    func buyBooster(_ booster: Booster) {
        if let gameState = gameState {
            booster.apply(to: gameState)
        }
    }
    
    func buyProPlayer(_ player: Player) {
        if let index = proPlayers.firstIndex(where: { $0.id == player.id }) {
            proPlayers[index].isPurchased = true
        }
    }
    
    func buyLegendPlayer(_ player: Player) {
        if let index = legendPlayers.firstIndex(where: { $0.id == player.id }) {
            legendPlayers[index].isPurchased = true
        }
    }
}

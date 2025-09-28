import Foundation
import SwiftUI

enum PlayerPosition: String, Codable {
    case goalkeeper = "Goalkeeper"
    case defenderLeft = "DefenderLeft"
    case defenderCenter = "DefenderCenter"
    case defenderRight = "DefenderRight"
    case forwardLeft = "ForwardLeft"
    case forwardRight = "ForwardRight"
}

enum PlayerType: String, Codable {
    case amateur = "Amateur"
    case pro = "Pro"
    case legend = "Legend"
}

struct Player: Identifiable, Codable {
    let id: UUID
    let position: PlayerPosition
    let type: PlayerType
    let image: String
    var name: String
    var price: Int?
    var isPurchased: Bool
    var isSelected: Bool
    
    init(position: PlayerPosition, image: String) {
        self.id = UUID()
        self.position = position
        self.type = .amateur
        self.image = image
        self.name = "Amateur \(position.rawValue)"
        self.price = nil
        self.isPurchased = false
        self.isSelected = true
    }
    
    init(name: String, type: PlayerType, position: PlayerPosition, image: String, price: Int) {
        self.id = UUID()
        self.position = position
        self.type = type
        self.image = image
        self.name = name
        self.price = price
        self.isPurchased = false
        self.isSelected = false
    }
}

class PlayerManager: ObservableObject {
    @Published var selectedPlayers: [PlayerPosition: Player] = [:]
    @Published var purchasedPlayers: [Player] = []
    
    private let purchasedPlayersKey = "purchasedPlayers"
    private let selectedPlayersKey = "selectedPlayers"
    
    init() {
        loadPurchasedPlayers()
        loadSelectedPlayers()
    }
    
    func savePurchasedPlayers() {
        if let encoded = try? JSONEncoder().encode(purchasedPlayers) {
            UserDefaults.standard.set(encoded, forKey: purchasedPlayersKey)
        }
    }
    
    func loadPurchasedPlayers() {
        if let savedData = UserDefaults.standard.data(forKey: purchasedPlayersKey),
           let decodedPlayers = try? JSONDecoder().decode([Player].self, from: savedData) {
            purchasedPlayers = decodedPlayers
        }
    }
    
    func saveSelectedPlayers() {
        var selectedPlayersArray: [Player] = []
        for (_, player) in selectedPlayers {
            selectedPlayersArray.append(player)
        }
        
        if let encoded = try? JSONEncoder().encode(selectedPlayersArray) {
            UserDefaults.standard.set(encoded, forKey: selectedPlayersKey)
        }
    }
    
    func loadSelectedPlayers() {
        if let savedData = UserDefaults.standard.data(forKey: selectedPlayersKey),
           let decodedPlayers = try? JSONDecoder().decode([Player].self, from: savedData) {
            for player in decodedPlayers {
                selectedPlayers[player.position] = player
            }
        }
    }
    
    func addPurchasedPlayer(_ player: Player) {
        var updatedPlayer = player
        updatedPlayer.isPurchased = true
        
        if let index = purchasedPlayers.firstIndex(where: { $0.id == player.id }) {
            purchasedPlayers[index] = updatedPlayer
        } else {
            purchasedPlayers.append(updatedPlayer)
        }
        
        savePurchasedPlayers()
    }
    
    func selectPlayer(_ player: Player) {
        var updatedPlayer = player
        updatedPlayer.isSelected = true
        
        selectedPlayers[player.position] = updatedPlayer
        
        if let index = purchasedPlayers.firstIndex(where: { $0.id == player.id }) {
            purchasedPlayers[index].isSelected = true
            
            for (i, p) in purchasedPlayers.enumerated() {
                if p.position == player.position && p.id != player.id {
                    purchasedPlayers[i].isSelected = false
                }
            }
        }
        
        saveSelectedPlayers()
        savePurchasedPlayers()
    }
    
    func isPlayerSelected(_ player: Player) -> Bool {
        if let selectedPlayer = selectedPlayers[player.position] {
            return selectedPlayer.type == player.type && selectedPlayer.position == player.position
        }
        return false
    }
    
    func getTeamType() -> PlayerType {
        guard selectedPlayers.count == 6 else {
            return .amateur
        }
        
        let types = Set(selectedPlayers.values.map { $0.type })
        
        if types.count == 1 {
            if let type = types.first {
                return type
            }
        }
        
        return .amateur
    }
    
    func getMatchPrize() -> Int {
        switch getTeamType() {
        case .amateur:
            return 20
        case .pro:
            return 40
        case .legend:
            return 60
        }
    }
}

import SwiftUI

enum Stat: String, CaseIterable {
    case teamSpirit = "Team Spirit"
    case fatigue = "Fatigue"
    case popularity = "Popularity"
    case strength = "Strength"
    
    var icon: ImageResource {
        switch self {
        case .teamSpirit: .teamSpirit
        case .fatigue: .fatigue
        case .popularity: .popularity
        case .strength: .strength
        }
    }
    
    var name: String {
        switch self {
        case .teamSpirit: "Team Spirit"
        case .fatigue: "Fatigue"
        case .popularity: "Popularity"
        case .strength: "Strength"
        }
    }
    
    var statColor: Color {
        switch self {
        case .teamSpirit: .colorOrange
        case .fatigue: .colorGreen
        case .popularity: .blue
        case .strength: .colorYellow
        }
    }
}

class GameState: ObservableObject {
    
    @AppStorage("teamSpirit") private var teamSpirit = 0.0
    @AppStorage("fatigue") private var fatigue = 0.0
    @AppStorage("popularity") private var popularity = 0.0
    @AppStorage("strength") private var strength = 0.0
    @AppStorage("isMatchReady") var isMatchReady = false
    @AppStorage("timeToMatch") private var timeToMatch = 300.0
    
    @Published var gameOverReason: GameOverReason?
    @Published var playerManager = PlayerManager()
    
    let players: [Player] = [
        Player(position: .goalkeeper, image: "goalkeeper"),
        Player(position: .defenderLeft, image: "defenderLeft"),
        Player(position: .defenderCenter, image: "defenderCenter"),
        Player(position: .defenderRight, image: "defenderRight"),
        Player(position: .forwardLeft, image: "forwardLeft"),
        Player(position: .forwardRight, image: "forwardRight")
    ]
    
    private var timer: Timer?
    
    init() {
        if !isMatchReady {
            startMatchTimer()
        }
        
        initializeDefaultPlayers()
    }
    
    private func initializeDefaultPlayers() {
        if playerManager.selectedPlayers.isEmpty {
            for player in players {
                playerManager.selectedPlayers[player.position] = player
            }
            playerManager.saveSelectedPlayers()
        }
    }
    
    func resetGame() {
        teamSpirit = 0.0
        fatigue = 0.0
        popularity = 0.0
        strength = 0.0
        isMatchReady = false
        timeToMatch = 300.0
        gameOverReason = nil
        
        startMatchTimer()
    }
    
    private func startMatchTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.timeToMatch > 0 {
                self.timeToMatch -= 1
            } else {
                self.isMatchReady = true
                timer.invalidate()
            }
        }
    }
    
    func canStartMatch() -> Bool {
        return isMatchReady &&
               teamSpirit >= 10 &&
               fatigue >= 10 &&
               popularity >= 10 &&
               strength >= 10
    }
    
    func formatTimeRemaining() -> String {
        let minutes = Int(timeToMatch) / 60
        let seconds = Int(timeToMatch) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func checkGameOver() {
        let teamSpiritValue = teamSpirit
        let fatigueValue = fatigue
        let popularityValue = popularity
        let strengthValue = strength
        
        let minValue = min(teamSpiritValue, min(fatigueValue, min(popularityValue, strengthValue)))
        
        if minValue == teamSpiritValue {
            gameOverReason = .teamSpiritLow
        } else if minValue == fatigueValue {
            gameOverReason = .fatigueLow
        } else if minValue == popularityValue {
            gameOverReason = .popularityLow
        } else if minValue == strengthValue {
            gameOverReason = .strengthLow
        }
    }
    
    func getStat(_ stat: Stat) -> Double {
        switch stat {
        case .teamSpirit:
            return teamSpirit / 100.0
        case .fatigue:
            return fatigue / 100.0
        case .popularity:
            return popularity / 100.0
        case .strength:
            return strength / 100.0
        }
    }
    
    func updateStat(_ stat: Stat, by amount: Double) {
        switch stat {
        case .teamSpirit:
            teamSpirit = min(max(teamSpirit + amount, 0), 100)
        case .fatigue:
            fatigue = min(max(fatigue + amount, 0), 100)
        case .popularity:
            popularity = min(max(popularity + amount, 0), 100)
        case .strength:
            strength = min(max(strength + amount, 0), 100)
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}

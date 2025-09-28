import SwiftUI
import Combine

enum HitResult {
    case ideal
    case normal
    case miss
    
    var title: String {
        switch self {
        case .ideal: "PERFECT!"
        case .normal: "GOOD!"
        case .miss: "MISS!"
        }
    }
}

class RhythmGameViewModel: ObservableObject {
    
    @Published var markerPosition: CGFloat = 0
    @Published var lastHitResult: HitResult?
    @Published var idealHits: Int = 0
    @Published var normalHits: Int = 0
    @Published var showResults: Bool = false
    
    let normalZoneRange: ClosedRange<CGFloat> = 0.30...0.70
    let idealZoneRange: ClosedRange<CGFloat> = 0.45...0.55
    let markerSpeed: CGFloat = 1.0
    let totalRounds: Int = 20
    
    var hitZoneRange: ClosedRange<CGFloat> { normalZoneRange }
    
    private var timer: Timer?
    private var direction: CGFloat = 1
    private var resultTimer: Timer?
    private var gameState: GameState?
    var currentRound: Int = 0
    
    init() {
        startGame()
    }
    
    func updateGameState(_ newGameState: GameState) {
        self.gameState = newGameState
    }
    
    func startGame() {
        markerPosition = 0
        idealHits = 0
        normalHits = 0
        currentRound = 0
        showResults = false
        direction = 1
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] _ in
            self?.updateMarkerPosition()
        }
    }
    
    func handleTap() {
        let result: HitResult
        if idealZoneRange.contains(markerPosition) {
            result = .ideal
            idealHits += 1
        } else if hitZoneRange.contains(markerPosition) {
            result = .normal
            normalHits += 1
        } else {
            result = .miss
        }
        
        lastHitResult = result
        resultTimer?.invalidate()
        
        resultTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.lastHitResult = nil
        }
        
        currentRound += 1
        SoundManager.shared.playTapSound()
        VibroManager.shared.softStyle()
        
        if currentRound >= totalRounds {
            endGame()
        }
    }
    
    private func updateMarkerPosition() {
        let step = 0.016 / markerSpeed
        markerPosition += step * direction
        
        if markerPosition >= 1.0 {
            markerPosition = 1.0
            direction = -1
        } else if markerPosition <= 0.0 {
            markerPosition = 0.0
            direction = 1
        }
    }
    
    private func endGame() {
        timer?.invalidate()
        timer = nil
        resultTimer?.invalidate()
        resultTimer = nil
        
        if let gameState = gameState {
            if idealHits >= 1 || normalHits >= 3 {
                gameState.updateStat(.strength, by: 45)
                gameState.updateStat(.teamSpirit, by: 45)
            } else {
                gameState.updateStat(.strength, by: 10)
                gameState.updateStat(.teamSpirit, by: 10)
            }
            gameState.updateStat(.fatigue, by: -5)
            updateActivityStats()
        }
        
        withAnimation {
            showResults = true
        }
    }
    
    private func updateActivityStats() {
        let statsViewModel = SettingsViewModel()
        statsViewModel.incrementActivityCompleted()
    }
    
    deinit {
        timer?.invalidate()
        resultTimer?.invalidate()
    }
}

import SwiftUI
import Combine

enum Signal: String, CaseIterable {
    case speak = "Speak"
    case silence = "Silence"
    case gesture = "Gesture"
    
    var image: ImageResource {
        switch self {
        case .speak: .speak
        case .silence: .silence
        case .gesture: .gesture
        }
    }
}

class MatchTimingViewModel: ObservableObject {
    
    @Published var currentSignal: Signal?
    @Published var showResults: Bool = false
    @Published var correctAnswers: Int = 0
    @Published var totalSignals: Int = 0
    @Published var buttonStates: [Signal: ButtonState] = [:]
    @Published var lastActionSignal: Signal?
    @Published var lastActionCorrect: Bool?
    
    let totalSignalsNeeded = 15
    private let signalDuration: TimeInterval = 2.0
    private let minInterval: TimeInterval = 1.0
    private let maxInterval: TimeInterval = 3.0
    
    private var timer: Timer?
    private var currentSignalTimer: Timer?
    private var gameState: GameState?
    
    struct ButtonState {
        var isPressed: Bool = false
        var isCorrect: Bool?
    }
    
    init() {
        Signal.allCases.forEach { signal in
            buttonStates[signal] = ButtonState()
        }
    }
    
    func updateGameState(_ newGameState: GameState) {
        self.gameState = newGameState
    }
    
    func startGame() {
        currentSignal = nil
        showResults = false
        correctAnswers = 0
        totalSignals = 0
        lastActionSignal = nil
        lastActionCorrect = nil
        
        Signal.allCases.forEach { signal in
            buttonStates[signal] = ButtonState()
        }
        
        scheduleNextSignal()
    }
    
    func handleAction(_ action: Signal) {
        guard let currentSignal = currentSignal else {
            buttonStates[action] = ButtonState(isPressed: true, isCorrect: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.buttonStates[action] = ButtonState()
            }
            return
        }
        
        let isCorrect = action == currentSignal
        
        lastActionSignal = action
        lastActionCorrect = isCorrect
        
        buttonStates[action] = ButtonState(isPressed: true, isCorrect: isCorrect)
        
        if isCorrect {
            correctAnswers += 1
        }
        
        SoundManager.shared.playTapSound()
        VibroManager.shared.softStyle()
        
        self.currentSignal = nil
        
        currentSignalTimer?.invalidate()
        currentSignalTimer = nil
        
        scheduleNextSignal()
    }
    
    private func scheduleNextSignal() {
        guard totalSignals < totalSignalsNeeded else {
            endGame()
            return
        }
        
        let delay = Double.random(in: minInterval...maxInterval)
        
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.showNextSignal()
        }
    }
    
    private func showNextSignal() {
        resetButtonStates()
        lastActionSignal = nil
        lastActionCorrect = nil
        currentSignal = Signal.allCases.randomElement()
        totalSignals += 1
        
        currentSignalTimer = Timer.scheduledTimer(withTimeInterval: signalDuration, repeats: false) { [weak self] _ in
            self?.currentSignal = nil
            self?.scheduleNextSignal()
        }
    }
    
    private func resetButtonStates() {
        Signal.allCases.forEach { signal in
            buttonStates[signal] = ButtonState()
        }
    }
    
    private func endGame() {
        timer?.invalidate()
        timer = nil
        currentSignalTimer?.invalidate()
        currentSignalTimer = nil
        
        if let gameState = gameState {
            if correctAnswers >= 5 {
                gameState.updateStat(.teamSpirit, by: 45)
                gameState.updateStat(.popularity, by: 45)
            } else {
                gameState.updateStat(.teamSpirit, by: 10)
                gameState.updateStat(.popularity, by: 10)
            }
            gameState.updateStat(.strength, by: -5)
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
        currentSignalTimer?.invalidate()
    }
}
 

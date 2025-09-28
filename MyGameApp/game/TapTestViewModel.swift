import SwiftUI
import Combine

struct QuestionBubble: Identifiable {
    let id = UUID()
    var position: CGPoint
    var scale: CGFloat = 0.5
    var offsetY: CGFloat = 10
    var isAppearing: Bool = true
}

class TapTestViewModel: ObservableObject {
    @Published var activeBubbles: [QuestionBubble] = []
    @Published var timeLeft: Double = 15.0
    @Published var successfulTaps: Int = 0
    @Published var showResults: Bool = false
    
    private var timer: Timer?
    private var gameState: GameState?
    private var animationTimers: [UUID: Timer] = [:]
    
    init() {
        startGame()
    }
    
    func updateGameState(_ newGameState: GameState) {
        self.gameState = newGameState
    }
    
    func startGame() {
        activeBubbles.removeAll()
        timeLeft = 15.0
        successfulTaps = 0
        showResults = false
        
        addNewBubble()
        addNewBubble()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    func handleBubbleTap(_ bubble: QuestionBubble) {
        if let index = activeBubbles.firstIndex(where: { $0.id == bubble.id }) {
            if let timer = animationTimers[bubble.id] {
                timer.invalidate()
                animationTimers.removeValue(forKey: bubble.id)
            }
            
            activeBubbles.remove(at: index)
            successfulTaps += 1
            SoundManager.shared.playTapSound()
            VibroManager.shared.softStyle()
            addNewBubble()
        }
    }
    
    private func updateTimer() {
        if timeLeft > 0 {
            timeLeft -= 0.016
        } else {
            endGame()
        }
    }
    
    private func addNewBubble() {
        let newBubble = QuestionBubble(
            position: CGPoint(
                x: CGFloat.random(in: 50...300),
                y: CGFloat.random(in: 100...400)
            )
        )
        activeBubbles.append(newBubble)
        
        startBubbleAnimation(bubbleId: newBubble.id)
    }
    
    private func startBubbleAnimation(bubbleId: UUID) {
        let animationTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] timer in
            guard let self = self,
                  let index = self.activeBubbles.firstIndex(where: { $0.id == bubbleId }) else {
                timer.invalidate()
                self?.animationTimers.removeValue(forKey: bubbleId)
                return
            }
            
            var bubble = self.activeBubbles[index]
            
            if bubble.isAppearing {
                bubble.scale += 0.03
                bubble.offsetY -= 0.5
                
                if bubble.scale >= 1.0 {
                    bubble.scale = 1.0
                    bubble.offsetY = 0
                    bubble.isAppearing = false
                }
            }
            
            self.activeBubbles[index] = bubble
        }
        
        animationTimers[bubbleId] = animationTimer
    }
    
    private func endGame() {
        timer?.invalidate()
        timer = nil
        
        for (_, timer) in animationTimers {
            timer.invalidate()
        }
        animationTimers.removeAll()
        
        if timeLeft <= 0, let gameState = gameState {
            if successfulTaps >= 5 {
                gameState.updateStat(.popularity, by: 45)
                gameState.updateStat(.fatigue, by: 45)
            } else {
                gameState.updateStat(.popularity, by: 10)
                gameState.updateStat(.fatigue, by: 10)
            }
            gameState.updateStat(.teamSpirit, by: -5)
            
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
        
        for (_, timer) in animationTimers {
            timer.invalidate()
        }
    }
}

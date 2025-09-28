import SwiftUI
import Combine

struct Bubble: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var isPopping: Bool = false
    var velocity: CGPoint
}

class AntistressViewModel: ObservableObject {
    @Published var activeBubbles: [Bubble] = []
    @Published var timeLeft: Double = 150.0
    @Published var showResults: Bool = false
    
    private var gameState: GameState?
    
    var timeString: String {
        let minutes = Int(timeLeft) / 60
        let seconds = Int(timeLeft) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private var timer: Timer?
    private var bubbleTimer: Timer?
    private var imageSize: CGSize = .zero
    private let bubbleSpeed: CGFloat = 60
    private var nextBubbleTime: TimeInterval = 0
    private let bubbleInterval: TimeInterval = 1.0
    
    func setImageSize(_ size: CGSize) {
        imageSize = size
    }
    
    init() {
        startGame()
    }
    
    func updateGameState(_ newGameState: GameState) {
        self.gameState = newGameState
    }
    
    func startGame() {
        activeBubbles.removeAll()
        timeLeft = 150.0
        showResults = false
        nextBubbleTime = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    func handleBubbleTap(_ bubble: Bubble) {
        
        if let index = activeBubbles.firstIndex(where: { $0.id == bubble.id }) {
            activeBubbles[index].isPopping = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.activeBubbles.remove(at: index)
                self?.addNewBubble()
            }
        }
    }
    
    private func updateTimer() {
        if timeLeft > 0 {
            timeLeft -= 0.016
            updateBubblePositions()
            
            nextBubbleTime -= 0.016
            if nextBubbleTime <= 0 && activeBubbles.count < 4 {
                addNewBubble()
                nextBubbleTime = bubbleInterval
            }
        } else {
            endGame()
        }
    }
    
    private func updateBubblePositions() {
        var bubblesForRemoval: [UUID] = []
        
        for (index, bubble) in activeBubbles.enumerated() {
            var newPosition = bubble.position
            newPosition.y -= bubbleSpeed * 0.016
            newPosition.x += bubble.velocity.x * 0.016
            
            newPosition.x = max(0, min(newPosition.x, imageSize.width))
            
            if newPosition.y < bubble.size {
                bubblesForRemoval.append(bubble.id)
                continue
            }
            
            activeBubbles[index].position = newPosition
        }
        
        activeBubbles.removeAll(where: { bubblesForRemoval.contains($0.id) })
    }
    
    private func addNewBubble() {
        guard activeBubbles.count < 4 else { return }
        
        let size = CGFloat.random(in: 40...60)
        let padding: CGFloat = size / 2
        
        let x = CGFloat.random(in: padding...(imageSize.width - padding))
        let y = imageSize.height
        
        let velocityX = CGFloat.random(in: -5...5)
        
        let newBubble = Bubble(
            position: CGPoint(x: x, y: y),
            size: size,
            velocity: CGPoint(x: velocityX, y: 0)
        )
        
        activeBubbles.append(newBubble)
    }
    
    private func endGame() {
        timer?.invalidate()
        timer = nil
        bubbleTimer?.invalidate()
        bubbleTimer = nil
        
        if timeLeft <= 0, let gameState = gameState {
            gameState.updateStat(.fatigue, by: 45)
            gameState.updateStat(.strength, by: 45)
            gameState.updateStat(.popularity, by: -5)
            
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
        bubbleTimer?.invalidate()
    }
}

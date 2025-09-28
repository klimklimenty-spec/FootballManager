import SwiftUI

class MatchViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var visibleCommentaries: [Commentary] = []
    @Published var isGameOver = false
    @Published var result: ResultState = .win
    @Published var prize = 0
    
    // MARK: - Private Properties
    
    private var matchTimer: Timer?
    private var commentaryIndex = 0
    let matchDuration: TimeInterval = 10
    private let commentaryDuration: TimeInterval = 2
    private var gameState: GameState?
    @AppStorage("balance") private var balance = 40
    
    private let commentaries = [
        "Kick-off!",
        "Player takes the ball...",
        "Dribbling towards goal...",
        "A powerful shot!",
        "What a save!",
        "Goal!",
        "It's a foul!",
        "Corner kick...",
        "Half time...",
        "Full time!"
    ]
    
    // MARK: - Models
    
    struct Commentary: Identifiable {
        let id = UUID()
        let text: String
        var position: CGPoint
        var opacity: Double
    }
    
    // MARK: - Public Methods
    
    func updateGameState(_ gameState: GameState) {
        self.gameState = gameState
    }
    
    func startMatch() {
        showCommentaries()
    }
    
    // MARK: - Private Methods
    
    private func showCommentaries() {
        addNewCommentary()
        
        matchTimer = Timer.scheduledTimer(withTimeInterval: commentaryDuration, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.visibleCommentaries.removeAll { $0.opacity == 0 }
            
            if self.commentaryIndex < self.commentaries.count {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.addNewCommentary()
                }
            }
        }
    }
    
    private func addNewCommentary() {
        let commentary = Commentary(
            text: commentaries[commentaryIndex],
            position: randomPosition(),
            opacity: 1
        )
        
        visibleCommentaries.append(commentary)
        commentaryIndex += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (commentaryDuration - 0.3)) { [weak self] in
            guard let self = self else { return }
            withAnimation(.easeOut(duration: 0.3)) {
                if let index = self.visibleCommentaries.firstIndex(where: { $0.id == commentary.id }) {
                    self.visibleCommentaries[index].opacity = 0
                }
            }
        }
    }
    
    private func randomPosition() -> CGPoint {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height - 150
        
        let xPadding: CGFloat = 60
        let yStart: CGFloat = screenHeight * 0.3
        let yEnd: CGFloat = screenHeight * 0.7
        
        let x = CGFloat.random(in: xPadding...(screenWidth - xPadding))
        let y = CGFloat.random(in: yStart...yEnd)
        
        return CGPoint(x: x, y: y)
    }
    
    func endMatch() {
        matchTimer?.invalidate()
        matchTimer = nil
        
        if let gameState = gameState {
            let teamSpirit = gameState.getStat(.teamSpirit) * 100
            let fatigue = gameState.getStat(.fatigue) * 100
            let popularity = gameState.getStat(.popularity) * 100
            let strength = gameState.getStat(.strength) * 100
            
            if teamSpirit < 40 || fatigue < 40 || popularity < 40 || strength < 40 {
                result = .lose
                gameState.checkGameOver()
                updateMatchStats(won: false)
            } else {
                result = .win
                prize = gameState.playerManager.getMatchPrize()
                balance += prize
                updateMatchStats(won: true)
            }
        }
        
        isGameOver = true
    }
    
    private func updateMatchStats(won: Bool) {
        let statsViewModel = SettingsViewModel()
        statsViewModel.incrementMatchStats(won: won)
    }
    
    deinit {
        matchTimer?.invalidate()
    }
}

import SwiftUI

struct StartView: View {
    
    @StateObject private var gameState = GameState()
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        if hasSeenOnboarding {
            FootballFieldView()
                .environmentObject(gameState)
        } else {
            OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
        }
    }
}

#Preview {
    StartView()
}

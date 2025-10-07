import SwiftUI

struct StartView: View {
    
    @StateObject private var gameState = GameState()
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        if hasSeenOnboarding {
            if #available(iOS 16.0, *) {
                FootballFieldView()
                    .environmentObject(gameState)
            } else {
                // Fallback on earlier versions
            }
        } else {
            OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
        }
    }
}

#Preview {
    StartView()
}

import SwiftUI

@available(iOS 15.0, *)
struct MatchView: View {
    
    //MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var gameState: GameState
    @StateObject private var viewModel = MatchViewModel()
    
    //MARK: - Body
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.onbordBg
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("Match")
                    .font(.poppins(size: 38, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.colorGray)
                
                ZStack {
                    Image(.matchBackground)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 20)
                    
                    ForEach(viewModel.visibleCommentaries) { commentary in
                        Text(commentary.text)
                            .font(.poppins(size: 18, weight: .semiBold))
                            .foregroundColor(.black)
                            .minimumScaleFactor(0.6)
                            .padding(8)
                            .frame(width: 120)
                            .multilineTextAlignment(.center)
                            .background(Color.colorLight)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .position(commentary.position)
                            .opacity(commentary.opacity)
                    }
                }
                .frame(maxHeight: .infinity)
                
                Color.colorGray
                    .frame(height: 80)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .hideNavigationBar()
        .onAppear {
            viewModel.updateGameState(gameState)
            viewModel.startMatch()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + viewModel.matchDuration) {
                viewModel.endMatch()
            }
        }
        .overlay {
            ZStack {
                if viewModel.isGameOver {
                    GameOverView(reason: gameState.gameOverReason,
                                 result: viewModel.result,
                                 prize: viewModel.prize) {
                        
                        gameState.resetGame()
                        dismiss()
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            .animation(.default, value: viewModel.isGameOver)
        }
    }
}

//MARK: - Preview

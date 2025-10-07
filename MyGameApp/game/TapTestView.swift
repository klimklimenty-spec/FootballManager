import SwiftUI

@available(iOS 15.0, *)
struct TapTestView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var gameState: GameState
    @StateObject private var viewModel: TapTestViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: TapTestViewModel())
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.onbordBg
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                HeaderView(title: "Tap Test") {
                    dismiss()
                }
                
                GeometryReader { geometry in
                    ZStack {
                        Image(.pressConference)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width - 32)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        ForEach(viewModel.activeBubbles) { bubble in
                            QuestionBubbleView(bubble: bubble) {
                                viewModel.handleBubbleTap(bubble)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxHeight: .infinity)
                
                VStack(spacing: 12) {
                    StatBox(
                        title: "Successful tap",
                        value: "\(viewModel.successfulTaps)",
                        color: .colorYellow
                    )
                    
                    StatBox(
                        title: "Time left 15 sec",
                        value: "\(Int(viewModel.timeLeft))s",
                        color: .colorOrange
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .hideNavigationBar()
        .overlay {
            ZStack {
                if viewModel.showResults {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                    
                    TapTestViewResultsView(
                        successfulTaps: viewModel.successfulTaps,
                        onDismiss: { dismiss() }
                    )
                    .transition(.move(edge: .bottom))
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.showResults)
        }
        .onAppear {
            viewModel.updateGameState(gameState)
        }
    }
}

// MARK: - Supporting Views

private struct StatBox: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.poppins(size: 14))
                .foregroundColor(.colorYellow)
            
            Text(value)
                .font(.poppins(size: 30, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.colorGray)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct QuestionBubbleView: View {
    let bubble: QuestionBubble
    let onTap: () -> Void
    
    var body: some View {
        Image(.questionBubble)
            .resizable()
            .frame(width: 60, height: 60)
            .scaleEffect(bubble.scale)
            .offset(y: bubble.offsetY)
            .position(x: bubble.position.x, y: bubble.position.y)
            .onTapGesture(perform: onTap)
    }
}

private struct TapTestViewResultsView: View {
    let successfulTaps: Int
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Game Over!")
                .font(.poppins(size: 32, weight: .bold))
            
            Text("You answered \(successfulTaps) questions!")
                .font(.poppins(size: 18))
            
            VStack(spacing: 20) {
                HStack(spacing: 40) {
                    StatChangeRow( stat: .popularity, change: .increase)
                    StatChangeRow(stat: .fatigue, change: .increase)
                }
                
                StatChangeRow(stat: .teamSpirit, change: .decrease)
            }
            .padding(.vertical, 24)
            
            Button {
                onDismiss()
            } label: {
                Text("Continue")
                    .font(.poppins(size: 18, weight: .semiBold))
                    .foregroundColor(.black)
                    .frame(width: 200, height: 50)
                    .background(Color.colorYellow)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .foregroundColor(.white)
        .padding(32)
        .background(Color.colorGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 32)
    }
}

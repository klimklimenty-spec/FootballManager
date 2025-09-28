import SwiftUI

struct AntistressView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var gameState: GameState
    @StateObject private var viewModel = AntistressViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.onbordBg
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                HeaderView(title: "Antistress") {
                    dismiss()
                }
                
                Text(viewModel.timeString)
                    .font(.poppins(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .frame(width: 120)
                    .background(Color.colorGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                GeometryReader { geometry in
                    let availableWidth = geometry.size.width - 32
                    let availableHeight = geometry.size.height
                    
                    ZStack {
                        Image(.relaxBackground)
                            .resizable()
                            .scaledToFit()
                            .frame(width: availableWidth)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .onAppear {
                                viewModel.setImageSize(CGSize(width: availableWidth, height: availableHeight))
                            }
                        
                        ForEach(viewModel.activeBubbles) { bubble in
                            BubbleView(bubble: bubble) {
                                viewModel.handleBubbleTap(bubble)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.horizontal, 20)
                
                Text("Pop the bubbles!")
                    .font(.poppins(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
            }
        }
        .hideNavigationBar()
        .overlay {
            ZStack {
                if viewModel.showResults {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                    
                    GameResultsView {
                        dismiss()
                    }
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

private struct BubbleView: View {
    let bubble: Bubble
    let onTap: () -> Void
    
    var body: some View {
        Image(.bubble)
            .resizable()
            .frame(width: bubble.size, height: bubble.size)
            .opacity(bubble.isPopping ? 0 : 1)
            .scaleEffect(bubble.isPopping ? 1.2 : 1)
            .position(bubble.position)
            .animation(.easeOut(duration: 0.2), value: bubble.isPopping)
            .onTapGesture(perform: onTap)
    }
}

private struct GameResultsView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Time's Up!")
                .font(.poppins(size: 32, weight: .bold))
            
            Text("You relaxed well!")
                .font(.poppins(size: 18))
            
            VStack(spacing: 20) {
                HStack(spacing: 40) {
                    StatChangeRow(stat: .fatigue, change: .increase)
                    StatChangeRow(stat: .strength, change: .increase)
                }
                StatChangeRow(stat: .popularity, change: .decrease)
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

#Preview {
    AntistressView()
        .environmentObject(GameState())
}

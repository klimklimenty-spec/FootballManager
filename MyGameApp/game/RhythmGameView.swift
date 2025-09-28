import SwiftUI

struct RhythmGameView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var gameState: GameState
    @StateObject private var viewModel = RhythmGameViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.onbordBg
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                HeaderView(title: "Rhythm Game") {
                    dismiss()
                }
                
                VStack(spacing: 12) {
                    
                    Text("Attempts: \(viewModel.currentRound)/\(viewModel.totalRounds)")
                        .font(.poppins(size: 16, weight: .semiBold))
                        .foregroundColor(.colorYellow)
                    
                    Image(.trainingField)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .layoutPriority(1)
                    
                    VStack {
                        if let result = viewModel.lastHitResult {
                            Text(result.title)
                                .font(.poppins(size: 32, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(height: 40)
                    .frame(maxHeight: .infinity)
                    
                    VStack(spacing: 4) {
                        Text("You got:")
                            .font(.poppins(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 24) {
                            ScoreView(count: viewModel.idealHits, type: .ideal)
                            ScoreView(count: viewModel.normalHits, type: .normal)
                        }
                    }
                    
                    RhythmBarView(
                        position: viewModel.markerPosition,
                        hitZoneRange: viewModel.hitZoneRange
                    )
                    
                    Button {
                        viewModel.handleTap()
                    } label: {
                        Text("Tap")
                            .font(.poppins(size: 20, weight: .semiBold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.colorYellow)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
        }
        .hideNavigationBar()
        .overlay {
            ZStack {
                if viewModel.showResults {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                    
                    RhythmGameResultsView(
                        idealHits: viewModel.idealHits,
                        normalHits: viewModel.normalHits,
                        onDismiss: { dismiss() }
                    )
                    .transition(.move(edge: .bottom))
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.showResults)
        }
        .onAppear {
            viewModel.updateGameState(gameState)
            viewModel.startGame()
        }
    }
}

// MARK: - Supporting Views

private struct ScoreView: View {
    let count: Int
    let type: HitResult
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(count)")
                .font(.poppins(size: 25, weight: .bold))
                .foregroundColor(.colorYellow)
            
            Text(type == .ideal ? "ideal" : "normal")
                .font(.poppins(size: 25))
                .foregroundColor(.white)
        }
    }
}

private struct RhythmBarView: View {
    let position: CGFloat
    let hitZoneRange: ClosedRange<CGFloat>
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 12) {
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: geometry.size.width * 0.30)
                    
                    Rectangle()
                        .fill(Color.colorGray)
                        .frame(width: geometry.size.width * 0.15)
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: geometry.size.width * 0.10)
                    
                    Rectangle()
                        .fill(Color.colorGray)
                        .frame(width: geometry.size.width * 0.15)
                    
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: geometry.size.width * 0.30)
                }
                .frame(height: 20)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(maxWidth: .infinity)
                    .frame(height: 16)
                    .overlay(
                        Image(.triangle)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .offset(x: geometry.size.width * position - geometry.size.width/2)
                    )
            }
            .padding(.top, 30)
        }
        .padding(.horizontal, 24)
        .frame(height: 100)
        .background(Color.colorGray.opacity(0.3), in: .rect(cornerRadius: 10))
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct RhythmGameResultsView: View {
    let idealHits: Int
    let normalHits: Int
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Training Complete!")
                .font(.poppins(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text("You got:")
                .font(.poppins(size: 18))
            
            VStack(spacing: 12) {
                ScoreView(count: idealHits, type: .ideal)
                ScoreView(count: normalHits, type: .normal)
            }
            
            VStack(spacing: 20) {
                HStack(spacing: 40) {
                    StatChangeRow(stat: .teamSpirit, change: .increase)
                    StatChangeRow(stat: .strength, change: .increase)
                }
                
                StatChangeRow(stat: .fatigue, change: .decrease)
            }
            
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
    RhythmGameView()
        .environmentObject(GameState())
}

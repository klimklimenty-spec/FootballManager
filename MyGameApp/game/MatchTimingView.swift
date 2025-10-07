import SwiftUI

@available(iOS 15.0, *)
struct MatchTimingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var gameState: GameState
    @StateObject private var viewModel = MatchTimingViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.onbordBg
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                HeaderView(title: "Match Timing") {
                    dismiss()
                }
                
                VStack(spacing: 16) {
                    Image(.coach)
                        .resizable()
                        .scaledToFit()
                        .layoutPriority(1)
                                        
                    VStack {
                        if let signal = viewModel.currentSignal {
                            SignalView(signal: signal)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .frame(height: 150)
                    .frame(maxHeight: .infinity)
                    
                    VStack(spacing: 12) {
                        ForEach(Signal.allCases, id: \.self) { signal in
                            ActionButton(
                                signal: signal,
                                state: viewModel.buttonStates[signal] ?? .init(),
                                isLastAction: signal == viewModel.lastActionSignal,
                                lastActionCorrect: viewModel.lastActionCorrect
                            ) {
                                viewModel.handleAction(signal)
                            }
                        }
                    }
                    .padding(.bottom, 8)
                }
                .padding(.horizontal, 20)
            }
        }
        .hideNavigationBar()
        .overlay {
            ZStack {
                if viewModel.showResults {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                    
                    MatchTimingResultsView(
                        correctAnswers: viewModel.correctAnswers,
                        totalSignals: viewModel.totalSignalsNeeded,
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

private struct SignalView: View {
    let signal: Signal
    
    var body: some View {
        VStack(spacing: 12) {
            Image(signal.image)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
            
            Text(signal.rawValue)
                .font(.poppins(size: 24, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(Color.colorGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct ActionButton: View {
    let signal: Signal
    let state: MatchTimingViewModel.ButtonState
    let isLastAction: Bool
    let lastActionCorrect: Bool?
    let action: () -> Void
    
    var backgroundColor: Color {
        if state.isPressed {
            return state.isCorrect == true ? .green : (state.isCorrect == false ? .red : .gray)
        } else if isLastAction {
            return lastActionCorrect == true ? .green.opacity(0.6) : .red.opacity(0.6)
        }
        return .white.opacity(0.3)
    }
    
    var body: some View {
        Button(action: action) {
            Text(signal.rawValue)
                .font(.poppins(size: 18, weight: .semiBold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

private struct MatchTimingResultsView: View {
    let correctAnswers: Int
    let totalSignals: Int
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Time's Up!")
                .font(.poppins(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text("Score: \(correctAnswers)/\(totalSignals)")
                .font(.poppins(size: 24))
            
            VStack(spacing: 20) {
                HStack(spacing: 40) {
                    StatChangeRow(stat: .teamSpirit, change: .increase)
                    StatChangeRow(stat: .popularity, change: .increase)
                }
                
                StatChangeRow(stat: .strength, change: .decrease)
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

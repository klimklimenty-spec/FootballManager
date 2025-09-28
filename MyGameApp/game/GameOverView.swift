import SwiftUI

enum ResultState {
    case win
    case lose
}

struct GameOverView: View {
    
    let reason: GameOverReason?
    let result: ResultState
    let prize: Int
    let backAction: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.onbordBg
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text(result == .win ? "You win!" : "Game Over")
                    .font(.poppins(size: 38, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color.colorGray)
                
                if result == .win {
                    VStack(spacing: 20) {
                        Image(.cup)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 20))
                        
                        Text("Congratulations!!!\nYour prize is \(prize)$")
                            .font(.poppins(size: 20, weight: .semiBold))
                            .foregroundColor(.colorYellow)
                            .multilineTextAlignment(.center)
                    }
                    .padding(20)
                    .frame(maxHeight: .infinity)
                } else {
                    Image(.gameOver)
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                        .overlay(alignment: .top) {
                            Text(reason?.message ?? "")
                                .font(.poppins(size: 20, weight: .semiBold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.top, 50)
                        }
                        .frame(maxHeight: .infinity)
                }
                
                Button {
                    backAction()
                } label: {
                    Text("Back to Menu")
                        .font(.poppins(size: 20, weight: .semiBold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.colorYellow)
                        }
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color.colorGray)
            }
        }
        .hideNavigationBar()
    }
}

enum GameOverReason {
    case teamSpiritLow
    case fatigueLow
    case popularityLow
    case strengthLow
    
    var message: String {
        switch self {
        case .teamSpiritLow:
            return "Team Spirit is too low"
        case .fatigueLow:
            return "Fatigue  is too low"
        case .popularityLow:
            return "Popularity  is too low"
        case .strengthLow:
            return "Strength is too low"
        }
    }
}

#Preview {
    GameOverView(reason: .teamSpiritLow, result: .lose, prize: 20) {}
}

import SwiftUI

struct PlayerCardView: View {
    @AppStorage("balance") private var balance = 40
    @EnvironmentObject private var gameState: GameState
    
    let player: Player
    let action: () -> Void
    
    private var canAfford: Bool {
        guard let price = player.price else { return false }
        return balance >= price
    }
    
    private var backgroundColor: Color {
        switch player.type {
        case .pro:
            return .colorGreen
        case .legend:
            return .colorYellow
        default:
            return .gray
        }
    }
    
    private var buttonText: String {
        if player.isPurchased {
            let isSelected = player.isSelected
            return isSelected ? "Selected" : "Select"
        } else {
            return "Buy"
        }
    }
    
    private var buttonColor: Color {
        if player.isPurchased {
            return player.isSelected ? Color.green : Color.blue
        } else {
            return backgroundColor
        }
    }
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Text("\(player.price ?? 20)$")
                    .font(.poppins(size: 14, weight: .bold))
                    .foregroundColor(canAfford ? backgroundColor : .red)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if player.type == .legend {
                    Image(.crown)
                        .resizable()
                        .frame(width: 22, height: 17)
                }
            }
            .padding(.horizontal, 4)
            
            Image(player.image)
                .resizable()
                .frame(width: 64, height: 90)
            
            Button(action: action) {
                Text(buttonText)
                    .font(.poppins(size: 10, weight: .regular))
                    .foregroundColor(player.isPurchased ? .white : .black)
                    .frame(width: 64, height: 25)
                    .background(buttonColor)
                    .cornerRadius(8)
            }
            .disabled(!player.isPurchased && !canAfford)
            
            Text(player.name)
                .font(.poppins(size: 10, weight: .semiBold))
                .foregroundColor(.white.opacity(0.5))
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 64)
    }
}

#Preview {
    ZStack {
        Color.onbordBg
        PlayerCardView(player: Player(name: "Pro Goalkeeper", type: .pro, position: .goalkeeper, image: "proGoalkeeper", price: 20)) {}
    }
}

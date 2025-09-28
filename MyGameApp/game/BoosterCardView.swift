import SwiftUI

struct BoosterCardView: View {
    
    @AppStorage("balance") private var balance = 40
    
    let booster: Booster
    let action: () -> Void
    
    private var canAfford: Bool {
        balance >= booster.price
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(booster.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(booster.name)
                        .font(.poppins(size: 20, weight: .semiBold))
                        .foregroundColor(.white)
                    
                    Text(booster.description)
                        .font(.poppins(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Text("\(booster.price)$")
                    .font(.poppins(size: 18, weight: .bold))
                    .foregroundColor(canAfford ? .colorYellow : .red)
            }
            .padding(.horizontal, 12)
            .frame(height: 66)
            .background(Color.colorGray)
            .cornerRadius(16)
        }
        .disabled(!canAfford)
    }
}

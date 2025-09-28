
import SwiftUI

struct StatCardView: View {
    let title: String
    let value: Int
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.poppins(size: 13, weight: .semiBold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(value)")
                .font(.poppins(size: 54, weight: .bold))
                .foregroundColor(.white)
                .minimumScaleFactor(0.5)
        }
        .padding(.horizontal, 12)
        .frame(width: 130, height: 120)
        .background(Color.colorGray)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ZStack {
        Color.onbordBg
        
        HStack(spacing: 12) {
            StatCardView(title: "Matches", value: 10)
            StatCardView(title: "Won", value: 7)
            StatCardView(title: "Lost", value: 3)
        }
        .padding()
    }
}

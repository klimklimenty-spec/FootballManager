import SwiftUI

struct StatItemView: View {
    let title: String
    let value: Int
    
    var body: some View {
        HStack {
            Text(title)
                .font(.poppins(size: 14, weight: .regular))
                .foregroundColor(.white)
            
            Spacer()
            
            Text("\(value)")
                .font(.poppins(size: 14, weight: .semiBold))
                .foregroundColor(.colorYellow)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.colorGray)
        .cornerRadius(12)
    }
}

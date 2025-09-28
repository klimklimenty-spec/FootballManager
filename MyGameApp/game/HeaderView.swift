
import SwiftUI

struct HeaderView: View {
        
    @AppStorage("balance") private var balance = 40
    
    let title: String
    let back: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                back()
            } label: {
                Image(.btnBack)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            Text(title)
                .font(.poppins(size: 25, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Image(.money)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 26)
                
                Text("\(balance)$")
                    .font(.poppins(size: 18, weight: .bold))
                    .foregroundColor(.colorYellow)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .frame(maxWidth: 100, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.colorGray)
    }
}

import SwiftUI

struct StatView: View {
    
    let stat: Stat
    let value: Double
    
    var body: some View {
        HStack(spacing: 8) {
            Image(stat.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 32)
            
            VStack(spacing: 8) {
                Text(stat.name)
                    .font(.poppins(size: 9))
                    .foregroundColor(.white)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(stat.statColor)
                            .frame(width: geometry.size.width * value)
                    }
                }
                .frame(maxWidth: 120)
                .frame(height: 11)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        StatView(stat: .fatigue, value: 0.5)
    }
}

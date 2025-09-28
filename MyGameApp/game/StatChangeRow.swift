import SwiftUI

enum StatChange {
    case increase
    case decrease
}

struct StatChangeRow: View {
    let stat: Stat
    let change: StatChange
    
    var body: some View {
        HStack(spacing: 4) {
            Image(stat.icon)
                .resizable()
                .scaledToFit()
                .frame(height: 34)
            
            Image(systemName: change == .increase ? "arrow.up" : "arrow.down")
                .foregroundColor(change == .increase ? .green : .red)
                .font(.system(size: 24, weight: .bold))
        }
    }
}

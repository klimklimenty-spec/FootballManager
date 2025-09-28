import SwiftUI

struct PlayerView: View {
    
    let player: Player
    
    var body: some View {
        Image(player.image)
            .resizable()
            .scaledToFit()
            .frame(height: 80)
    }
    
    private var playerImage: ImageResource {
        switch player.position {
        case .goalkeeper: .goalkeeper
        case .defenderLeft: .defenderLeft
        case .defenderCenter: .defenderCenter
        case .defenderRight: .defenderRight
        case .forwardLeft: .forwardLeft
        case .forwardRight: .forwardRight
        }
    }
}

#Preview {
    PlayerView(player: Player(position: .goalkeeper, image: "goalkeeper"))
}

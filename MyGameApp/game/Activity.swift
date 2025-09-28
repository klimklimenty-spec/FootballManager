import SwiftUI

enum Activity: CaseIterable {
    case tapTest
    case rhythmGame
    case antistress
    case matchTiming
    
    var icon: ImageResource {
        switch self {
        case .tapTest: .tapTest
        case .rhythmGame: .rhythmGame
        case .antistress: .antistress
        case .matchTiming: .matchTiming
        }
    }
    
    var title: String {
        switch self {
        case .tapTest: "Tap Test"
        case .rhythmGame: "Rhythm Game"
        case .antistress: "Antistress"
        case .matchTiming: "Match Timing"
        }
    }
    
    var description: String {
        switch self {
        case .tapTest: "Test your tapping speed and accuracy"
        case .rhythmGame: "Follow the rhythm to improve team coordination"
        case .antistress: "Relax and reduce team fatigue"
        case .matchTiming: "Practice perfect timing for matches"
        }
    }
    
    
    var increasedStats: (Stat, Stat) {
        switch self {
        case .tapTest: (.popularity, .fatigue)
        case .rhythmGame: (.strength, .teamSpirit)
        case .antistress: (.fatigue, .strength)
        case .matchTiming: (.teamSpirit, .popularity)
        }
    }
    
    var decreasedStats: Stat {
        switch self {
        case .tapTest: .teamSpirit
        case .rhythmGame: .fatigue
        case .antistress: .popularity
        case .matchTiming: .strength
        }
    }
    
    @ViewBuilder func view() -> some View {
        switch self {
        case .tapTest: TapTestView()
        case .rhythmGame: RhythmGameView()
        case .antistress: AntistressView()
        case .matchTiming: MatchTimingView()
        }
    }
}

struct ActivityCardView: View {
    
    let activity: Activity
    
    var body: some View {
        NavigationLink {
            activity.view()
        } label: {
            HStack(spacing: 28) {
                // Icon
                Image(activity.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(activity.title)
                        .font(.poppins(size: 25, weight: .bold))
                    
                    Text(activity.description)
                        .font(.poppins(size: 14))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    HStack(spacing: 24) {
                        HStack(spacing: 4) {
                            Image(activity.increasedStats.0.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            Image(systemName: "arrow.up")
                                .foregroundColor(.green)
                                .font(.system(size: 16, weight: .bold))
                        }
                        
                        HStack(spacing: 4)  {
                            Image(activity.increasedStats.1.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            Image(systemName: "arrow.up" )
                                .foregroundColor(.green)
                                .font(.system(size: 16, weight: .bold))
                        }
                        
                        HStack(spacing: 4)  {
                            Image(activity.decreasedStats.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            Image(systemName: "arrow.down")
                                .foregroundColor(.red)
                                .font(.system(size: 16, weight: .bold))
                        }
                        
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .frame(height: 140)
            .background(Color.colorGray)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    ZStack {
        Color.onbordBg
        ActivityCardView(activity: .tapTest)
    }
}

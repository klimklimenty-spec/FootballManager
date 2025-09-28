import SwiftUI

struct FootballFieldView: View {
    @EnvironmentObject private var gameState: GameState
    @AppStorage("balance") private var balance = 40
    @State private var showGameOver = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.onbordBg
                    .ignoresSafeArea()
                
                VStack(spacing: 8) {
                    ZStack {
                        Text("Football field")
                            .font(.poppins(size: 25, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack {
                            NavigationLink {
                                SettingsView()
                            } label: {
                                Image(.settings)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 44)
                            }
                            
                            Spacer()
                            
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
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 4)
                    .background(Color.colorGray)
                    
                    VStack(spacing: 4) {
                        if gameState.isMatchReady {
                            Text("Match is Ready!")
                                .font(.poppins(size: 34, weight: .bold))
                                .foregroundColor(.colorYellow)
                        } else {
                            Text("Next Match:")
                                .font(.poppins(size: 14))
                                .foregroundColor(.white)
                            
                            Text(gameState.formatTimeRemaining())
                                .font(.poppins(size: 30, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 182, height: 47)
                                .background(Color.colorGray, in: .rect(cornerRadius: 10))
                        }
                    }
                    .frame(height: 72)
                    
                    ZStack(alignment: .top) {
                        Image(.fieldBackground)
                            .resizable()
                        
                        VStack(spacing: 30) {
                            PlayerView(player: getPlayerForPosition(.goalkeeper))
                            
                            HStack(spacing: 20) {
                                PlayerView(player: getPlayerForPosition(.defenderLeft))
                                PlayerView(player: getPlayerForPosition(.defenderCenter))
                                PlayerView(player: getPlayerForPosition(.defenderRight))
                            }
                            
                            HStack(spacing: 40) {
                                PlayerView(player: getPlayerForPosition(.forwardLeft))
                                PlayerView(player: getPlayerForPosition(.forwardRight))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 16) {
                        VStack {
                            HStack(spacing: 30) {
                                ForEach([Stat.teamSpirit, Stat.strength], id: \.self) { stat in
                                    StatView(stat: stat, value: gameState.getStat(stat))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            HStack(spacing: 30) {
                                ForEach([Stat.popularity, Stat.fatigue], id: \.self) { stat in
                                    StatView(stat: stat, value: gameState.getStat(stat))
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(8)
                        .background(Color.colorGray, in: .rect(cornerRadius: 10))
                        .padding(.horizontal, 20)
                        
                        HStack(alignment: .bottom, spacing: 8) {
                            NavigationLink {
                                ShopView()
                            } label: {
                                Text("Shop")
                                    .font(.poppins(size: 16, weight: .semiBold))
                                    .foregroundColor(.black)
                                    .frame(width: 102, height: 42)
                                    .background(Color.colorLight, in: .rect(cornerRadius: 9))
                            }
                            
                            NavigationLink {
                                MatchView()
                            } label: {
                                Text(gameState.isMatchReady ? "Start Match" : "Preparing for the Match")
                                    .font(.poppins(size: 12, weight: .semiBold))
                                    .lineLimit(2)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .padding(.horizontal, 12)
                                    .background(gameState.isMatchReady ? Color.colorYellow : Color.gray, in: .rect(cornerRadius: 12))
                                    .multilineTextAlignment(.center)
                            }
                            .disabled(!gameState.isMatchReady)
                            
                            NavigationLink {
                                ActivitiesView()
                            } label: {
                                Text("Activities")
                                    .font(.poppins(size: 16, weight: .semiBold))
                                    .foregroundColor(.black)
                                    .frame(width: 102, height: 42)
                                    .background(Color.colorLight, in: .rect(cornerRadius: 9))
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 8)
                }
            }
            .hideNavigationBar()
        }
    }
    
    private func getPlayerForPosition(_ position: PlayerPosition) -> Player {
        return gameState.playerManager.selectedPlayers[position] ??
        gameState.players.first(where: { $0.position == position }) ??
        Player(position: position, image: getDefaultImageFor(position))
    }
    
    private func getDefaultImageFor(_ position: PlayerPosition) -> String {
        switch position {
        case .goalkeeper: return "goalkeeper"
        case .defenderLeft: return "defenderLeft"
        case .defenderCenter: return "defenderCenter"
        case .defenderRight: return "defenderRight"
        case .forwardLeft: return "forwardLeft"
        case .forwardRight: return "forwardRight"
        }
    }
}

#Preview {
    FootballFieldView()
        .environmentObject(GameState())
}

extension View {
    func hideNavigationBar() -> some View {
        self
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden()
    }
}

extension PlayerPosition: CaseIterable {
    static var allCases: [PlayerPosition] {
        return [.goalkeeper, .defenderLeft, .defenderCenter, .defenderRight, .forwardLeft, .forwardRight]
    }
}

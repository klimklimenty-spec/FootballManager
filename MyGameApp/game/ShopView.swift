import SwiftUI

@available(iOS 15.0, *)
struct ShopView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ShopViewModel()
    @EnvironmentObject private var gameState: GameState
    @AppStorage("balance") private var balance = 40
    @State private var refreshView = false
    
    var body: some View {
        ZStack {
            Color.onbordBg
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HeaderView(title: "Shop") {
                    dismiss()
                }
                
                if #available(iOS 16.0, *) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Boosters")
                                .font(.poppins(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(viewModel.boosters) { booster in
                                    BoosterCardView(booster: booster) {
                                        if balance >= booster.price {
                                            balance -= booster.price
                                            viewModel.buyBooster(booster)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 20)
                        
                        Text("Players")
                            .font(.poppins(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Pro")
                                .font(.poppins(size: 14, weight: .regular))
                                .foregroundColor(.colorYellow)
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 8) {
                                    ForEach(viewModel.proPlayers) { player in
                                        PlayerCardView(player: updatePlayerState(player)) {
                                            handlePlayerAction(player)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .id(refreshView)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Legend")
                                .font(.poppins(size: 14, weight: .regular))
                                .foregroundColor(.colorYellow)
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 8) {
                                    ForEach(viewModel.legendPlayers) { player in
                                        PlayerCardView(player: updatePlayerState(player)) {
                                            handlePlayerAction(player)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .id(!refreshView)
                            }
                        }
                        .padding(.bottom, 8)
                    }
                    .scrollIndicators(.hidden)
                } else {
                    // Fallback on earlier versions
                }
            }
            .hideNavigationBar()
        }
        .onAppear {
            viewModel.updateGameState(gameState)
            syncPlayersWithManager()
        }
    }
    
    private func updatePlayerState(_ player: Player) -> Player {
        var updatedPlayer = player
        
        if gameState.playerManager.purchasedPlayers.contains(where: { $0.position == player.position && $0.type == player.type }) {
            updatedPlayer.isPurchased = true
            
            if let purchasedPlayer = gameState.playerManager.purchasedPlayers.first(where: { $0.position == player.position && $0.type == player.type }) {
                updatedPlayer.isSelected = gameState.playerManager.isPlayerSelected(purchasedPlayer)
            }
        }
        
        return updatedPlayer
    }
    
    private func syncPlayersWithManager() {
        for i in 0..<viewModel.proPlayers.count {
            let player = viewModel.proPlayers[i]
            
            if gameState.playerManager.purchasedPlayers.contains(where: { $0.position == player.position && $0.type == player.type }) {
                viewModel.proPlayers[i].isPurchased = true
                
                let isSelected = gameState.playerManager.isPlayerSelected(player)
                viewModel.proPlayers[i].isSelected = isSelected
            }
        }
        
        for i in 0..<viewModel.legendPlayers.count {
            let player = viewModel.legendPlayers[i]
            
            if gameState.playerManager.purchasedPlayers.contains(where: { $0.position == player.position && $0.type == player.type }) {
                viewModel.legendPlayers[i].isPurchased = true
                
                let isSelected = gameState.playerManager.isPlayerSelected(player)
                viewModel.legendPlayers[i].isSelected = isSelected
            }
        }
        
        refreshView.toggle()
    }
    
    private func handlePlayerAction(_ player: Player) {
        if gameState.playerManager.purchasedPlayers.contains(where: { $0.position == player.position && $0.type == player.type }) {
            if let purchasedPlayer = gameState.playerManager.purchasedPlayers.first(where: { $0.position == player.position && $0.type == player.type }) {
                gameState.playerManager.selectPlayer(purchasedPlayer)
            }
            
            syncPlayersWithManager()
        } else if let price = player.price, balance >= price {
            balance -= price
            
            gameState.playerManager.addPurchasedPlayer(player)
            
            if player.type == .pro {
                viewModel.buyProPlayer(player)
                updatePlayerStats(isLegend: false)
            } else if player.type == .legend {
                viewModel.buyLegendPlayer(player)
                updatePlayerStats(isLegend: true)
            }
            
            syncPlayersWithManager()
        }
    }
    
    private func updatePlayerStats(isLegend: Bool) {
        let statsViewModel = SettingsViewModel()
        statsViewModel.incrementPlayerBought(isLegend: isLegend)
    }
}

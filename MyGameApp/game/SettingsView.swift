import SwiftUI
import AVKit
import StoreKit

@available(iOS 15.0, *)
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.onbordBg
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HeaderView(title: "Settings") {
                    dismiss()
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        HStack(spacing: 20) {
                            HStack(spacing: 8) {
                                Text("Vibro")
                                    .font(.poppins(size: 14, weight: .regular))
                                    .foregroundColor(.white)
                                
                                Toggle("", isOn: $viewModel.isVibroEnabled)
                                    .labelsHidden()
                                    .toggleStyle(CustomToggleStyle())
                            }
                            
                            HStack(spacing: 8) {
                                Text("SFX")
                                    .font(.poppins(size: 14, weight: .regular))
                                    .foregroundColor(.white)
                                
                                Toggle("", isOn: $viewModel.isSoundEnabled)
                                    .labelsHidden()
                                    .toggleStyle(CustomToggleStyle())
                            }
                        }
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Matches")
                                .font(.poppins(size: 16, weight: .semiBold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    StatCardView(title: "Played", value: viewModel.stats.matchesPlayed)
                                    StatCardView(title: "Won", value: viewModel.stats.matchesWon)
                                    StatCardView(title: "Lost", value: viewModel.stats.matchesLost)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Stats")
                                .font(.poppins(size: 16, weight: .semiBold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    StatCardView(title: "Activities", value: viewModel.stats.activitiesCompleted)
                                    StatCardView(title: "Spirit", value: viewModel.stats.maxSpiritReached)
                                    StatCardView(title: "Strength", value: viewModel.stats.maxStrengthReached)
                                    StatCardView(title: "Popularity", value: viewModel.stats.maxPopularityReached)
                                    StatCardView(title: "Fatigue", value: viewModel.stats.maxFatigueReached)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Players")
                                .font(.poppins(size: 16, weight: .semiBold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    StatCardView(title: "Pro", value: viewModel.stats.proPlayersBought)
                                    StatCardView(title: "Legend", value: viewModel.stats.legendPlayersBought)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        HStack(spacing: 6) {
                            Button(action: {
                                guard let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                                SKStoreReviewController.requestReview(in: currentScene)
                            }) {
                                HStack {
                                    Image(systemName: "star.fill")
                                    Text("Rate App")
                                }
                                .font(.poppins(size: 16, weight: .semiBold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 62)
                                .background(Color.colorYellow)
                                .cornerRadius(8)
                            }
                            Button(action: {
                                guard let urlShare = URL(string: "https://itunes.apple.com/us/app/myapp/idYOUR_APP_ID?ls=1&mt=8") else { return }
                                   let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)

                                   // Получаем текущий активный windowScene
                                   if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                      let rootVC = scene.windows.first?.rootViewController {
                                       rootVC.present(activityVC, animated: true, completion: nil)
                                   }
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Share App")
                                }
                                .font(.poppins(size: 16, weight: .semiBold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 62)
                                .background(Color.colorYellow)
                                .cornerRadius(8)
                            }
                        }
                        .padding([.horizontal, .top], 20)

                    }
                }
            }
        }
        .hideNavigationBar()
        .onAppear {
            viewModel.updateMaxStats()
        }
    }
}



class SoundManager {
  
    @AppStorage("isSoundEnabled") var isSoundEnabled = true
    
    static let shared = SoundManager()
        
    var player: AVAudioPlayer?
        
    func playTapSound() {
        guard isSoundEnabled else { return }
        guard let url = Bundle.main.url(forResource: "tap", withExtension: "wav") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private init () {}
}

class VibroManager {
    
    @AppStorage("isVibroEnabled") var isVibroEnabled = true
    
    static let shared = VibroManager()
    
    func softStyle() {
        guard isVibroEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
    
    private init() {}
}



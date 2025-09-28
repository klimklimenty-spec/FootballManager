import SwiftUI

struct OnboardingSlide: Identifiable {
    let id = UUID()
    let image: ImageResource
    let description: String
}

struct OnboardingView: View {
    
    @Binding var hasSeenOnboarding: Bool
    
    @State private var currentPage = 0
    
    let slides = [
        OnboardingSlide(
            image: .managerIcon,
            description: "Welcome to Football Manager Tycoon! - You are the manager! Build your dream team and lead them to victory!"
        ),
        OnboardingSlide(
            image: .workMatchIcon,
            description: "Work Hard, Play Hard! - Engage in Activities to improve your team's skills and earn resources. Then, start the Match to test your preparation!"
        ),
        OnboardingSlide(
            image: .gameOverIcon,
            description: " Don't Get Fired! - If your team's Spirit or Strength is too low for a match, or if any stat vessel empties, your journey ends! Manage wisely!"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.onbordBg
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                TabView(selection: $currentPage) {
                    ForEach(slides.indices, id: \.self) { index in
                        VStack(spacing: 24) {
                            Image(slides[index].image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 296, height: 296)
                            
                            Text(slides[index].description)
                                .font(.poppins(size: 16))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .overlay(
                    Button(action: {
                        hasSeenOnboarding = true
                    }) {
                        Text("Skip")
                            .font(.poppins(size: 14))
                            .foregroundColor(.white)
                    }
                        .padding(),
                    alignment: .topTrailing
                )
                
                HStack(spacing: 8)  {
                    ForEach(0..<slides.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(currentPage == index ? Color.colorYellow : .gray)
                            .frame(width: currentPage == index ? 60 : 30, height: 6)
                    }
                }
                .animation(.default, value: currentPage)
                .padding(.bottom)
                
                Button(action: {
                    if currentPage == slides.count - 1 {
                        hasSeenOnboarding = true
                    } else {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                }) {
                    Text(currentPage == slides.count - 1 ? "Start Managing" : "Next")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .padding(.horizontal, 20)
                        .background(Color.colorYellow)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
}


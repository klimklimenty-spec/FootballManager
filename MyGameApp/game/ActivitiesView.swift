import SwiftUI

@available(iOS 15.0, *)
struct ActivitiesView: View {
    
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        ZStack(alignment: .top) {
            Color.onbordBg
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HeaderView(title: "Activities") {
                    dismiss()
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        ForEach(Activity.allCases, id: \.self) { activity in
                            ActivityCardView(activity: activity)
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(maxHeight: .infinity)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                }
            }
        }
        .hideNavigationBar()
    }
}

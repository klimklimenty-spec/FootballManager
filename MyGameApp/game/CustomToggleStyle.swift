import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    var onColor: Color = .white
    var offColor: Color = .colorGray
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 92, height: 36)
                
                Circle()
                    .fill(Color.colorYellow)
                    .frame(width: 36, height: 36)
                    .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
                    .offset(x: configuration.isOn ? 28 : -28)
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.3)) {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        Toggle("", isOn: .constant(true))
            .toggleStyle(CustomToggleStyle())
            .labelsHidden()
        
        Toggle("", isOn: .constant(false))
            .toggleStyle(CustomToggleStyle())
            .labelsHidden()
    }
    .padding(30)
    .background(Color.onbordBg)
}

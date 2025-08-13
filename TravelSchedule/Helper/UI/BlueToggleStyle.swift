import SwiftUI

struct BlueToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? .blueUniversal : Color.gray.opacity(0.3))
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 1, x: 0, y: 1)
                        .padding(2)
                        .offset(x: configuration.isOn ? 10 : -10)
                )
                .animation(.spring(), value: configuration.isOn)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

import SwiftUI

struct RadioButtonToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                .overlay(
                    Circle()
                        .stroke(configuration.isOn ? Color.blackDay : Color.blackDay, lineWidth: 2)
                )
            if configuration.isOn {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.blackDay)
            }
        }
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
}

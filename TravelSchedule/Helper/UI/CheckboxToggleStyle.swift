import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(configuration.isOn ? .blackDay : .blackDay)
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}

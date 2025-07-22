import SwiftUI

struct RadioButton: View {
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.blackDay : Color.blackDay, lineWidth: 2)
                )
            if isSelected {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.blackDay)
            }
        }
        .onTapGesture {
            action()
        }
    }
}

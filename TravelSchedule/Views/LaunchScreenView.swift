import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        Image("launch_screen")
            .resizable()
            .ignoresSafeArea()
    }
}

#Preview {
    LaunchScreenView()
}

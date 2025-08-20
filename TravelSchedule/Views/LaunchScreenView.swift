import SwiftUI

struct LaunchScreenView: View {

    var body: some View {
        Image(.launchScreen)
            .resizable()
            .ignoresSafeArea()

    }
}

#Preview {
    LaunchScreenView()
}

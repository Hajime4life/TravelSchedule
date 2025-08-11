import SwiftUI

struct ErrorView: View {
    let error: NetworkError
    let retryAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.whiteDay.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image("\(error == .noInternet ? "no_internet" : "server_error")")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 223, height: 223)
                    .foregroundColor(.red)
                
                Text(error == .noInternet ? "Нет интернета" : "Ошибка сервера")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.blackDay)
            }
            .padding()
        }
    }
}

#Preview {
    ErrorView(error: .noInternet, retryAction: {})
}

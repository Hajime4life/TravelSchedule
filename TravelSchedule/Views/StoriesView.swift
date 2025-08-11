import SwiftUI

struct StoriesView: View {
    @State private var images: [String] = [
        "st_1",
        "st_2",
        "st_3",
        "st_4"
    ]
    @State private var selectedImage: String?
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(images, id: \.self) { image in
                    StoriesItemView(image: image)
                        .onTapGesture {
                            selectedImage = image
                        }
                }
            }
            .padding(.leading)
        }
        .sheet(isPresented: Binding(
            get: { selectedImage != nil },
            set: { if !$0 { selectedImage = nil } }
        )) {
            if let image = selectedImage {
                FullScreenImageView(image: image)
                    .preferredColorScheme(settingsViewModel.isDark ? .dark : .light)
            }
        }
        .preferredColorScheme(settingsViewModel.isDark ? .dark : .light)
    }
}

struct StoriesItemView: View {
    let image: String
    
    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 88, height: 136)
                .cornerRadius(16)
                .padding(4)
                .background(Color.blueUniversal)
                .cornerRadius(16)
        }
    }
}

struct FullScreenImageView: View {
    let image: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .edgesIgnoringSafeArea(.top)
                .clipShape(
                    UnevenRoundedRectangle(
                        cornerRadii: RectangleCornerRadii(
                            topLeading: 0,
                            bottomLeading: 40,
                            bottomTrailing: 40,
                            topTrailing: 0
                        ),
                        style: .continuous
                    )
                )
                .offset(y: -7)
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        ZStack {
                            Circle()
                                .foregroundColor(.blackUniversal)
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.white)
                        }
                        .frame(width: 30, height: 30)
                        
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
}

struct StoriesView_Previews: PreviewProvider {
    static var previews: some View {
        StoriesView()
    }
}

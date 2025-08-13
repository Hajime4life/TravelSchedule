import SwiftUI

struct StoryView: View {
    @EnvironmentObject private var storiesViewModel: StoryViewModel
    let story: Story

    var body: some View {
        Image(story.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: .infinity)
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        Text(story.title)
                            .font(.bold34)
                            .foregroundColor(.white)
                        Text(story.description)
                            .font(.regular20)
                            .lineLimit(3)
                            .foregroundColor(.white)
                    }
                    .padding(.init(top: 0, leading: 16, bottom: 40, trailing: 16))
                }
            )
//            .clipShape(
//                UnevenRoundedRectangle(
//                    cornerRadii: RectangleCornerRadii(
//                        topLeading: 0,
//                        bottomLeading: 40,
//                        bottomTrailing: 40,
//                        topTrailing: 0
//                    ),
//                    style: .continuous
//                )
//            )
            .onDisappear() {
                storiesViewModel.storyWasViewed(story)
            }

    }
}

#Preview {
    StoryView(story: .story4)
        .environmentObject(StoryViewModel())
}

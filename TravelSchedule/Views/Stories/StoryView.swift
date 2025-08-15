import SwiftUI

struct StoryView: View {
    @EnvironmentObject private var storiesViewModel: StoryViewModel
    let storyState: StoryViewModel.StoryViewState

    var body: some View {
        Image(storyState.story.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: .infinity)
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        Text(storyState.story.title)
                            .font(.bold34)
                            .foregroundColor(.white)
                        Text(storyState.story.description)
                            .font(.regular20)
                            .lineLimit(3)
                            .foregroundColor(.white)
                    }
                    .padding(.init(top: 0, leading: 16, bottom: 40, trailing: 16))
                }
            )
            .onDisappear() {
                storiesViewModel.storyWasViewed(storyState.story.id)
            }
    }
}

#Preview {
    StoryView(storyState: StoryViewModel.StoryViewState(story: .story4))
        .environmentObject(StoryViewModel())
}

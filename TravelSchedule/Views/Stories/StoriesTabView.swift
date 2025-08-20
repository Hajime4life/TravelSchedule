import SwiftUI

struct StoriesTabView: View {
    @EnvironmentObject private var storiesViewModel: StoryViewModel
    @Binding var currentStoryIndex: Int

    var body: some View {
        TabView(selection: $currentStoryIndex) {
            ForEach(storiesViewModel.stories) { storyState in
                StoryView(storyState: storyState)
                    .onTapGesture {
                        didTapStory()
                    }
                    .environmentObject(storiesViewModel)
            }
        }
        .ignoresSafeArea()
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }

    func didTapStory() {
        currentStoryIndex = min(currentStoryIndex + 1, storiesViewModel.storiesCount - 1)
    }
}

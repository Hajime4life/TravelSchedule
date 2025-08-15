import SwiftUI

struct StoriesListView: View {
    @StateObject private var storiesViewModel = StoryViewModel()
    @State private var showStoryInFullscreen: Bool = false
    @State private var selectedStoryIdx: Int? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(storiesViewModel.stories) { storyState in
                    Image(storyState.story.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: storyState.isViewed ? 92 : 88,
                            height: storyState.isViewed ? 140 : 136
                        )
                        .cornerRadius(storyState.isViewed ? 0 : 16)
                        .padding(storyState.isViewed ? 0 : 4)
                        .background(Color.blueUniversal.opacity(storyState.isViewed ? 0 : 1))
                        .cornerRadius(16)
                        .opacity(storyState.isViewed ? 0.5 : 1.0)
                        .onTapGesture {
                            Task {
                                selectedStoryIdx = storyState.story.id
                                showStoryInFullscreen = true
                            }
                        }
                }
            }
            .padding(.leading)
        }
        .task {
            await storiesViewModel.loadInitialStories()
        }
        .fullScreenCover(isPresented: $showStoryInFullscreen) {
            StoriesView(
                show: $showStoryInFullscreen,
                startIndex: selectedStoryIdx,
                storiesCount: storiesViewModel.storiesCount
            )
            .environmentObject(storiesViewModel)
        }
        
    }
}

#Preview {
    StoriesListView()
}

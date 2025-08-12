import SwiftUI

struct StoriesListView: View {
    @StateObject private var storiesViewModel = StoryViewModel()
    @State private var showStoryInFullscreen: Bool = false
    @State private var selectedStoryIdx: Int? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(storiesViewModel.stories.sorted(by: { !$0.isViewed && $1.isViewed })) { story in
                    Image(story.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: story.isViewed ? 92 : 88, height: story.isViewed ? 140 : 136)
                        .cornerRadius(story.isViewed ? 0 : 16)
                        .padding(story.isViewed ? 0 : 4)
                        .background(Color.blueUniversal.opacity(story.isViewed ? 0 : 1))
                        .cornerRadius(16)
                        .opacity(story.isViewed ? 0.5 : 1.0)
                        .onTapGesture {
                            openStory(story.id)
                        }
                }
            }
            .padding(.leading)
        }
        .sheet(
            isPresented: $showStoryInFullscreen
        ) {
                StoriesView(
                    show: $showStoryInFullscreen,
                    startIndex: selectedStoryIdx,
                    storiesCount: storiesViewModel.storiesCount,
                )
                .environmentObject(storiesViewModel)
            
        }
    }
    
    private func openStory(_ storyID: Int) {
        Task {
            selectedStoryIdx = storyID
            showStoryInFullscreen = true
        }
    }
}

#Preview {
    StoriesListView()
}

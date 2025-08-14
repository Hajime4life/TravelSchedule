import SwiftUI

final class StoryViewModel: ObservableObject {
    @Published var stories: [Story] = [.story1, .story2, .story3, .story4, .story5]
    
    var storiesCount: Int {
        return stories.count
    }
    
    func storyWasViewed(_ story: Story) {
        withAnimation {
            if let index = stories.firstIndex(where: { $0.id == story.id }) {
                stories[index].isViewed = true
            }
        }
    }
}

import SwiftUI

@MainActor
final class StoryViewModel: ObservableObject {
    struct StoryViewState: Identifiable, Sendable {
        let id: Int
        let story: Story
        var isViewed: Bool = false

        init(story: Story) {
            self.id = story.id
            self.story = story
        }
    }

    @Published var stories: [StoryViewState] = []
    @Published var isLoading: Bool = false
    @Published var error: NetworkError?
    
    func loadInitialStories() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let mockStories: [Story] = [.story1, .story2, .story3, .story4, .story5]
            stories = mockStories.map { StoryViewState(story: $0) }
        } catch { // Сделаем вид что это сетевой запрос...
            self.error = .serverError
        }
    }

    func storyWasViewed(_ storyId: Int) {
        withAnimation {
            if let index = stories.firstIndex(where: { $0.story.id == storyId }) {
                stories[index].isViewed = true
            }
        }
    }

    var storiesCount: Int {
        stories.count
    }
}

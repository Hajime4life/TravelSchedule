import SwiftUI

struct StoriesView: View {
    @EnvironmentObject private var storiesViewModel: StoryViewModel
    
    private var timerConfiguration: TimerConfiguration {
        .init(
            storiesCount: storiesViewModel.storiesCount
        )
    }
    
    @Binding var show: Bool
    @State var currentStoryIndex: Int
    @State var currentProgress: CGFloat
    
    init(show: Binding<Bool>, startIndex: Int? = nil, storiesCount: Int) {
        self._show = show
        self._currentStoryIndex = State(initialValue: startIndex ?? 0)
        self._currentProgress = State(initialValue: TimerConfiguration(storiesCount: storiesCount).progress(for: startIndex ?? 0))
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .topTrailing) {
                StoriesTabView(
                    currentStoryIndex: $currentStoryIndex
                )
                .onChange(of: currentStoryIndex) { oldValue, newValue in
                    didChangeCurrentIndex(oldIndex: oldValue, newIndex: newValue)
                }
                .environmentObject(storiesViewModel)

                StoriesProgressBar(
                    storiesCount: storiesViewModel.storiesCount,
                    timerConfiguration: timerConfiguration,
                    currentProgress: $currentProgress
                )
                .padding(.init(top: 28, leading: 12, bottom: 12, trailing: 12))
                .onChange(of: currentProgress) { _, newValue in
                    didChangeCurrentProgress(newProgress: newValue)
                }
            }
            
            Button(action: {
                self.show = false
            }) {
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
            .padding(.top, 57)
            .padding(.trailing, 22)
        }
    }

    private func didChangeCurrentIndex(oldIndex: Int, newIndex: Int) {
        guard oldIndex != newIndex else { return }
        let progress = timerConfiguration.progress(for: newIndex)
        guard abs(progress - currentProgress) >= 0.01 else { return }
        withAnimation {
            currentProgress = progress
        }
    }

    private func didChangeCurrentProgress(newProgress: CGFloat) {
        let index = timerConfiguration.index(for: newProgress)
        guard index != currentStoryIndex else { return }
        withAnimation {
            currentStoryIndex = index
        }
    }
}

#Preview {
    StoriesView(show: .constant(true), startIndex: 1, storiesCount: StoryViewModel().storiesCount)
        .environmentObject(StoryViewModel())
}

import SwiftUI
import Combine

import SwiftUI

struct StoriesProgressBar: View {
    let storiesCount: Int
    let timerConfiguration: TimerConfiguration
    @Binding var currentProgress: CGFloat
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 0.1, on: .main, in: .common)
    @State private var cancellable: Cancellable?

    init(
        storiesCount: Int,
        timerConfiguration: TimerConfiguration,
        currentProgress: Binding<CGFloat>
    ) {
        self.storiesCount = storiesCount
        self.timerConfiguration = timerConfiguration
        self._currentProgress = currentProgress
    }

    var body: some View {
        ProgressBar(numberOfSections: storiesCount, progress: currentProgress)
            .padding(.init(top: 7, leading: 12, bottom: 12, trailing: 12))
            .onAppear {
                cancellable = timer.connect()
            }
            .onDisappear {
                cancellable?.cancel()
            }
            .onReceive(timer) { _ in
                timerTick()
            }
    }

    private func timerTick() {
        withAnimation {
            currentProgress = timerConfiguration.nextProgress(progress: currentProgress)
            if currentProgress >= 1.0 {
                currentProgress = 0
            }
        }
    }
}

extension StoriesProgressBar {
    private static func makeTimer(configuration: TimerConfiguration) -> Timer.TimerPublisher {
        Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common)
    }
}

import SwiftUI
#if DEBUG
import netfox
#endif

@main
struct TravelScheduleApp: App {
    init() {
        #if DEBUG
        NFX.sharedInstance().start()
        #endif
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

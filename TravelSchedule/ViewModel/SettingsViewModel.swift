import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Published var isDark: Bool {
        didSet {
            UserDefaults.standard.set(isDark, forKey: "isDarkMode")
        }
    }
    
    init() {
        self.isDark = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
}

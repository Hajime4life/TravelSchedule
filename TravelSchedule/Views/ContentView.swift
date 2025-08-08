import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var stationsViewModel = StationsViewModel()
    @StateObject var navigation = NavigationViewModel()
    @StateObject var carrierViewModel = CarrierViewModel()
    
    @State private var selectedTabIndex: Int8 = 0
    
    private enum TabItemType: Int8, CaseIterable {
        case schedule = 0
        case settings = 1
        
        var iconName: String {
            switch self {
                case .schedule: return "schedule_tab_ic"
                case .settings: return "settings_tab_ic"
            }
        }
        
        var index: Int8 {
            return self.rawValue
        }
    }
    
    var body: some View {
        ZStack {
            if stationsViewModel.isLoading {
                LaunchScreenView()
            } else {
                TabView(selection: $selectedTabIndex) {
                    MainView()
                        .environmentObject(stationsViewModel)
                        .environmentObject(carrierViewModel)
                        .tabItem {
                            TabItem(
                                iconName: TabItemType.schedule.iconName,
                                isActive: selectedTabIndex == TabItemType.schedule.index)
                        }
                        .tag(TabItemType.schedule.index)
                    
                    Text("Настройки")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.whiteDay)
                        .tabItem {
                            TabItem(
                                iconName: TabItemType.settings.iconName,
                                isActive: selectedTabIndex == TabItemType.settings.index)
                        }
                        .tag(TabItemType.settings.index)
                }
            }
        }
        .environmentObject(navigation)
        .onAppear {
            stationsViewModel.loadCities()
        }
    }
    
    @ViewBuilder private func TabItem(iconName: String, isActive: Bool) -> some View {
        Image("\(iconName)\(isActive ? "_active" : "")\(isActive && colorScheme == .dark ? "_night": "")")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
    }
}

#Preview {
    ContentView()
}

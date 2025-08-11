import SwiftUI

final class NavigationViewModel: ObservableObject {
    @Published var showTabBar: Visibility = .visible
    @Published var path: [Screen] = []
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path = []
    }
}

enum Screen: Hashable {
    case home
    case cityList
    case stationsList
    case carrierList
}

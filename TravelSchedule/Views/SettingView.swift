import SwiftUI

struct SettingView : View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var navigation: NavigationViewModel

    @State private var isOn = false
    var body: some View {
        NavigationView {
            VStack(spacing: 25){
                    Toggle("Темная тема", isOn: $settingsViewModel.isDark)
                        .toggleStyle(BlueToggleStyle())
                    
                NavigationLink(destination: PrivacyPolicyView()
                    .colorScheme(.light)) {
                    HStack {
                        Text("Пользовательское соглашение")
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
                }
                
                Spacer()
                VStack(spacing: 16){
                    Text("Приложение использует API «Яндекс.Расписания»")
                    Text("Версия 1.0 (beta)")
                }
                .font(.system(size: 12))
            }
            .foregroundColor(.blackDay)
            .padding()
            .background(Color.whiteDay)
            .toolbar(navigation.showTabBar, for: .tabBar)
            .onAppear() {
                navigation.showTabBar = .visible
            }

        }
    }
}



#Preview {
    SettingView()
        .environmentObject(SettingsViewModel())
}

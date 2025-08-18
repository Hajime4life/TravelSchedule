import SwiftUI
import OpenAPIURLSession

struct StationSearchView: View {
    @EnvironmentObject var stationsViewModel: StationsViewModel
    @EnvironmentObject var navigation: NavigationViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(stationsViewModel.filteredStations, id: \.self) { station in
                        Button(action: {
                            stationsViewModel.setSelectedStation(station)
                        }) {
                            HStack {
                                Text(station.title ?? "(Нет названия)")
                                    .padding(.vertical, 17)
                                Spacer()
                                Image(systemName: "chevron.forward")
                            }
                            .foregroundColor(.blackDay)
                            .padding(.horizontal)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .searchable(
                text: $stationsViewModel.searchStationText,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: Text("Введите запрос")
            )
            .navigationTitle("Станции")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                if stationsViewModel.isNoStations() {
                    Text("Станция не найдена")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.blackDay)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.whiteDay)
        }
    }
}

#Preview {
    StationSearchView()
        .environmentObject(StationsViewModel())
        .environmentObject(NavigationViewModel())
}

import SwiftUI
import OpenAPIURLSession

struct StationSearchView: View {
    @EnvironmentObject var stationsViewModel: StationsViewModel
    @EnvironmentObject var navigation: NavigationViewModel
    
    @State private var searchText: String = ""
    
    var filteredStations: [Components.Schemas.Station] {
        let allStations = stationsViewModel.allCities.flatMap { $0.stations ?? [] }
        let filtered = searchText.isEmpty ? allStations : allStations.filter { station in
            station.title?.lowercased().contains(searchText.lowercased()) ?? false
        }
        return Array(filtered.reduce(into: [String: Components.Schemas.Station]()) { dict, station in
            if let yandexCode = station.codes?.yandex_code {
                dict[yandexCode, default: station] = station
            }
        }.values)
            .filter { $0.transport_type == "train" }
            .filter { $0.title != nil && !$0.title!.isEmpty }
            .sorted { $0.title! < $1.title! }
    }
    
    var body: some View {
        VStack {
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredStations, id: \.self) { station in
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
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: Text("Введите запрос")
            )
            .navigationTitle("Станции")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                if filteredStations.isEmpty && !searchText.isEmpty {
                    Text("Станция не найдена")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.blackDay)
                }
            }
        }
    }
}

#Preview {
    StationSearchView()
        .environmentObject(StationsViewModel(apiKey: "your-api-key"))
        .environmentObject(NavigationViewModel())
}

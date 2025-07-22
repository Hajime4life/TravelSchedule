import SwiftUI
import OpenAPIURLSession

struct StationSearchView: View {
    let selectedSettlement: Components.Schemas.Settlement
    @Binding var selectedStation: Components.Schemas.Station?
    @Binding var navigateToStationPicker: Bool
    @State private var searchText: String = ""
    
    var filteredStations: [Components.Schemas.Station] {
        
        let stations = searchText.isEmpty ? (selectedSettlement.stations ?? []) : (selectedSettlement.stations ?? []).filter { station in
            station.title?.lowercased().contains(searchText.lowercased()) ?? false
        }
        
        // Удаляем дубликаты по yandex_code, если оно доступно
        let uniqueStations = stations.reduce(into: [String: Components.Schemas.Station]()) { dict, station in
            if let yandexCode = station.codes?.yandex_code {
                dict[yandexCode, default: station] = station
            }
        }.values
        
        return Array(uniqueStations)
            .filter { $0.transport_type == "train" } // Только станции для поездов
            .filter { $0.title != nil && !$0.title!.isEmpty } // Исключаем nil или пустой title
            .sorted { $0.title! < $1.title! } // Сортировка по алфавиту
    }
    
    var body: some View {
        List(filteredStations, id: \.self) { station in
            Button(action: {
                selectedStation = station
                navigateToStationPicker = false
            }) {
                HStack {
                    Text(station.title ?? "(Нет названия)")
                        .padding(.vertical, 8)
                    Spacer()
                }
            }
            .listRowSeparator(.hidden)
            .buttonStyle(.plain)
            .simultaneousGesture(TapGesture().onEnded {
                selectedStation = station
                navigateToStationPicker = false
            })
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .automatic),
            prompt: Text("Введите запрос")
        )
        .listStyle(.plain)
        .navigationTitle("Станции \(selectedSettlement.title ?? "(Нет названия)")")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("") {
                    navigateToStationPicker = false
                }
            }
        }
        .overlay {
            if filteredStations.isEmpty {
                Text("Станция не найдена")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.blackDay)
            }
        }
        .onChange(of: searchText) { _, newValue in

        }
        .onAppear {

        }
    }
}

#Preview {
    StationSearchView(
        selectedSettlement: Components.Schemas.Settlement(title: "Москва", stations: []),
        selectedStation: .constant(nil),
        navigateToStationPicker: .constant(false)
    )
}

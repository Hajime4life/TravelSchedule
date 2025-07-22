import SwiftUI
import OpenAPIURLSession

struct CitySearchView: View {
    @EnvironmentObject private var viewModel: StationsViewModel
    @Binding var selectedStation: Components.Schemas.Station?
    @Binding var navigateToStationPicker: Bool
    @State private var searchText: String = ""
    @State private var selectedCity: Components.Schemas.Settlement?
    
    var filteredCities: [Components.Schemas.Settlement] {
        let cities = searchText.isEmpty ? viewModel.allCities : viewModel.allCities.filter { city in
            city.title?.lowercased().contains(searchText.lowercased()) ?? false
        }
        return cities
            .filter { $0.title != nil && !$0.title!.isEmpty }
            .sorted { $0.title! < $1.title! }
    }
    
    var body: some View {
        List(filteredCities, id: \.self) { city in
            Button(action: {
                selectedCity = city
            }) {
                HStack {
                    Text(city.title ?? "(Нет названия)")
                        .padding(.vertical, 8)
                    Spacer()
                }
            }
            .listRowSeparator(.hidden)
            .buttonStyle(.plain)
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .automatic),
            prompt: Text("Введите запрос")
        )
        .listStyle(.plain)
        .navigationTitle("Выбор города")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("") {
                    navigateToStationPicker = false
                }
            }
        }
        .navigationDestination(isPresented: Binding(
            get: { selectedCity != nil },
            set: { if !$0 { selectedCity = nil } }
        )) {
            if let city = selectedCity {
                StationSearchView(
                    selectedSettlement: city,
                    selectedStation: $selectedStation,
                    navigateToStationPicker: $navigateToStationPicker
                )
                .environmentObject(viewModel)
            }
        }
        .overlay {
            if filteredCities.isEmpty {
                Text("Город не найден")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.blackDay)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    CitySearchView(selectedStation: .constant(nil), navigateToStationPicker: .constant(false))
        .environmentObject(StationsViewModel(apiKey: apiKey))
}

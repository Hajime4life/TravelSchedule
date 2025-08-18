import SwiftUI
import OpenAPIURLSession

struct CitySearchView: View {
    @EnvironmentObject private var viewModel: StationsViewModel
    @EnvironmentObject private var navigation: NavigationViewModel
    
    @State private var searchText: String = ""
    @State private var selectedCity: CityModel?
    
    var filteredCities: [CityModel] {
        let cities = searchText.isEmpty ? viewModel.allCities : viewModel.allCities.filter { city in
            city.title?.lowercased().contains(searchText.lowercased()) ?? false
        }
        return cities
            .filter { $0.title != nil && !$0.title!.isEmpty }
            .sorted { $0.title! < $1.title! }
    }
    
    var body: some View {
        ScrollView {
            if !filteredCities.isEmpty {
                LazyVStack(spacing: 0) {
                    ForEach(filteredCities, id: \.self) { city in
                        Button(action: {
                            selectedCity = city
                            navigation.push(.stationsList)
                        }) {
                            HStack {
                                Text(city.title ?? "(Нет названия)")
                                    .padding(.vertical, 17)
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .foregroundColor(.accentColor)
                            }
                            .padding(.horizontal)
                            .foregroundColor(.blackDay)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .automatic),
            prompt: Text("Введите запрос")
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Выбор города")
        .overlay {
            if filteredCities.isEmpty && !searchText.isEmpty {
                Text("Город не найден")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.blackDay)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.whiteDay)
    }
    
}

#Preview {
    let st = StationsViewModel()
    CitySearchView()
        .environmentObject(st)
        .environmentObject(NavigationViewModel())
        .onAppear() {
            st.loadCities()
        }
}

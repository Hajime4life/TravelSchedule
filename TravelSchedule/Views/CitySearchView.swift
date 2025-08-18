import SwiftUI
import OpenAPIURLSession

struct CitySearchView: View {
    @EnvironmentObject private var viewModel: StationsViewModel
    @EnvironmentObject private var navigation: NavigationViewModel
    
    var body: some View {
        ScrollView {
            if !viewModel.filteredCities.isEmpty {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.filteredCities, id: \.self) { city in
                        Button(action: {
                            viewModel.selectedCity = city
                            if viewModel.selectedCity != nil {
                                navigation.push(.stationsList)
                            }
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
            text: $viewModel.searchCityText,
            placement: .navigationBarDrawer(displayMode: .automatic),
            prompt: Text("Введите запрос")
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Выбор города")
        .overlay {
            if viewModel.filteredCities.isEmpty && !viewModel.searchCityText.isEmpty {
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
}

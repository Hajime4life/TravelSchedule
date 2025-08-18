import SwiftUI
import OpenAPIURLSession

struct MainView: View {
    @EnvironmentObject var stationsViewModel: StationsViewModel
    @EnvironmentObject var navigation: NavigationViewModel
    @EnvironmentObject var carrierViewModel: CarrierViewModel
    @State private var searchTextFrom: String = "Откуда"
    @State private var searchTextTo: String = "Куда"

    var body: some View {
        NavigationStack(path: $navigation.path) {
            ZStack {
                Color.whiteDay.ignoresSafeArea()
                VStack {
                    StoriesListView()
                        .padding(.bottom, 44)
                    
                    StationSelectionView(searchTextFrom: $searchTextFrom, searchTextTo: $searchTextTo)
                        .padding(.horizontal)
                    
                    if stationsViewModel.isStationsSelected {
                        Button(action: {
                            navigation.push(.carrierList)
                        }) {
                            Text("Найти")
                                .fontWeight(.bold)
                                .foregroundColor(.whiteUniversal)
                                .padding(.horizontal, 45)
                                .padding(.vertical, 20)
                                .background(Color.blueUniversal)
                                .cornerRadius(16)
                        }
                    }
                    
                    Spacer()
                }
                .navigationDestination(for: Screen.self, destination: destinationView)
                .onChange(of: stationsViewModel.selectedFromStation) { from in
                    searchTextFrom = from?.title ?? "Откуда"
                    navigation.popToRoot()
                }
                .onChange(of: stationsViewModel.selectedToStation) { to in
                    searchTextTo = to?.title ?? "Куда"
                    navigation.popToRoot()
                }
                
                if let error = stationsViewModel.error {
                    ErrorView(error: error) {
                        Task {
                            stationsViewModel.clearError()
                            await stationsViewModel.loadCities()
                        }
                    }
                    .ignoresSafeArea()
                } else if let error = carrierViewModel.error {
                    ErrorView(error: error) {
                        Task {
                            carrierViewModel.clearError()
                            if
                                let from = stationsViewModel.selectedFromStation?.code,
                                let to = stationsViewModel .selectedToStation?.code {
                                    await carrierViewModel.loadRaces(
                                        from: from,
                                        to: to
                                    )
                            }
                        }
                    }
                    .ignoresSafeArea()
                }
            }
        }
    }
}

extension MainView {
    @ViewBuilder
    private func destinationView(for screen: Screen) -> some View {
        switch screen {
        case .home:
            EmptyView()
        case .cityList:
            CitySearchView()
                .toolbar(.hidden, for: .tabBar)
                .environmentObject(stationsViewModel)
                .environmentObject(carrierViewModel)
                .environmentObject(navigation)
        case .stationsList:
            StationSearchView()
                .toolbar(.hidden, for: .tabBar)
                .environmentObject(stationsViewModel)
                .environmentObject(carrierViewModel)
                .environmentObject(navigation)
        case .carrierList:
            CarrierListView()
                .toolbar(.hidden, for: .tabBar)
                .environmentObject(stationsViewModel)
                .environmentObject(carrierViewModel)
                .environmentObject(navigation)
        }
    }
}

struct StationSelectionView: View {
    @EnvironmentObject var stationsViewModel: StationsViewModel
    @EnvironmentObject var navigation: NavigationViewModel
    @Binding var searchTextFrom: String
    @Binding var searchTextTo: String

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                Text(searchTextFrom)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        stationsViewModel.isSelectingFrom = true
                        navigation.push(.cityList)
                    }
                    .padding(.vertical, 7)
                    .foregroundColor(stationsViewModel.selectedFromStation == nil ? .grayUniversal : .blackUniversal)

                Text(searchTextTo)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        stationsViewModel.isSelectingFrom = false
                        navigation.push(.cityList)
                    }
                    .padding(.vertical, 7)
                    .foregroundColor(stationsViewModel.selectedToStation == nil ? .grayUniversal : .blackUniversal)
            }
            .padding()
            .background(Color.whiteUniversal)
            .cornerRadius(20)

            Button(action: {
                stationsViewModel.switchStations()
            }) {
                Image("switch_ic")
                    .frame(width: 32, height: 32)
            }
            .padding(.leading)
            .disabled(!stationsViewModel.isStationsSelected)
        }
        .padding()
        .background(Color.blueUniversal)
        .cornerRadius(20)
    }
}

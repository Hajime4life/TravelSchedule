import SwiftUI
import OpenAPIURLSession

struct MainView: View {
    @State private var searchTextFrom: String = "Откуда"
    @State private var searchTextTo: String = "Куда"
    @State private var selectedFromStation: Components.Schemas.Station? = nil
    @State private var selectedToStation: Components.Schemas.Station? = nil
    @State private var navigateToStationPicker = false
    @State private var isSelectingFrom = true
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text(searchTextFrom)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(selectedFromStation == nil ? 0.25 : 1)
                            .onTapGesture {
                                isSelectingFrom = true
                                navigateToStationPicker = true
                            }
                            .padding(.vertical, 7)
                        Text(searchTextTo)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(selectedToStation == nil ? 0.25 : 1)
                            .onTapGesture {
                                isSelectingFrom = false
                                navigateToStationPicker = true
                            }
                            .padding(.vertical, 7)
                    }
                    .padding()
                    .background(Color.whiteUniversal)
                    .cornerRadius(20)
                    
                    Button(action: {
                        // TODO:  Проверить ок ли?
                        if selectedFromStation != nil && selectedToStation != nil {
                            let tempText = searchTextFrom
                            searchTextFrom = searchTextTo
                            searchTextTo = tempText
                            
                            let tempStation = selectedFromStation
                            selectedFromStation = selectedToStation
                            selectedToStation = tempStation
                        }
                    }) {
                        Image("switch_ic")
                            .frame(width: 32, height: 32)
                    }
                    .padding(.leading)
                }
                .padding()
                .background(Color.blueUniversal)
                .cornerRadius(20)
                
                if let from = selectedFromStation, let to = selectedToStation {
                    NavigationLink(destination: CarrierListView(
                        fromStation: from,
                        toStation: to)) {
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
            .padding(.horizontal)
            .navigationDestination(isPresented: $navigateToStationPicker) {
                CitySearchView(
                    selectedStation: isSelectingFrom ? $selectedFromStation : $selectedToStation,
                    navigateToStationPicker: $navigateToStationPicker
                )
            }
            .onChange(of: selectedFromStation) { newValue in
                searchTextFrom = newValue?.title ?? "Откуда"
            }
            .onChange(of: selectedToStation) { newValue in
                searchTextTo = newValue?.title ?? "Куда"
            }
        }
    }
}

#Preview {
    MainView()
}


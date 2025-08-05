import SwiftUI
import OpenAPIURLSession
import Combine

class StationsViewModel: ObservableObject {
    @Published var allCities: [Components.Schemas.Settlement] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var isSelectingFrom: Bool = true // Чтобы понять "Откуда" или "Куда" выбрали
    @Published var selectedFromStation: Components.Schemas.Station? = nil
    @Published var selectedToStation: Components.Schemas.Station? = nil
    
    var isStationsSelected: Bool {
        selectedFromStation != nil && selectedToStation != nil
    }
    
    private let stationsService: StationsService
    
    init(apiKey: String) {
        do {
            self.stationsService = StationsService(
                apiKey: apiKey,
                client: Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
            )
        } catch {
            fatalError("Ошибка инициализации StationsService: \(error.localizedDescription)")
        }
    }
    
    func loadCities() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let allCities = try await stationsService.getFilteredCities()
                let filteredCities = allCities.filter { settlement in
                    guard let stations = settlement.stations else { return false }
                    return stations.contains { $0.transport_type == "train" }
                }
                await MainActor.run {
                    self.allCities = filteredCities
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Ошибка загрузки городов: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    func switchStations() {
        if self.isStationsSelected {
            let tempStation = selectedFromStation
            selectedFromStation = selectedToStation
            selectedToStation = tempStation
        }
    }
    
    func setSelectedStation(_ station: Components.Schemas.Station?) {
        if isSelectingFrom {
            selectedFromStation = station
        } else {
            selectedToStation = station
        }
    }

}

import SwiftUI
import OpenAPIURLSession
import Combine

final class StationsViewModel: ObservableObject {
    @Published var allCities: [CityModel] = []
    @Published var isLoading: Bool = false
    @Published var error: NetworkError? = nil
    
    @Published var isSelectingFrom: Bool = true
    @Published var selectedFromStation: StationModel? = nil
    @Published var selectedToStation: StationModel? = nil
    
    var isStationsSelected: Bool {
        selectedFromStation != nil && selectedToStation != nil
    }
    
    private let stationsService: StationsService
    
    init() {
        do {
            self.stationsService = StationsService(
                apiKey: Constants.apiKey,
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
        error = nil
        
        Task {
            do {
                let allCities = try await stationsService.getFilteredCities()
                let filteredCities = allCities.filter { settlement in
                    guard let stations = settlement.stations else { return false }
                    return stations.contains { $0.transport_type == "train" }
                }
                await MainActor.run {
                    self.allCities = filteredCities.map { settlement in
                        var modifiedSettlement = settlement
                        modifiedSettlement.stations = settlement.stations?.filter { $0.transport_type == "train" }
                        return modifiedSettlement
                    }
                    self.isLoading = false
                    self.error = nil
                }
            } catch URLError.Code.notConnectedToInternet {
                await MainActor.run {
                    self.error = .noInternet
                    self.isLoading = false
                    self.allCities = []
                }
            } catch {
                await MainActor.run {
                    self.error = .serverError
                    self.isLoading = false
                    self.allCities = []
                }
            }
        }
    }
    
    func clearError() {
        error = nil
    }
    
    func switchStations() {
        if isStationsSelected {
            let tempStation = selectedFromStation
            selectedFromStation = selectedToStation
            selectedToStation = tempStation
        }
    }
    
    func setSelectedStation(_ station: StationModel?) {
        guard let station = station, station.transport_type == "train" else { return }
        if isSelectingFrom {
            selectedFromStation = station
        } else {
            selectedToStation = station
        }
    }
    
    func getTrainStations(from settlement: CityModel) -> [StationModel] {
        return settlement.stations?.filter { $0.transport_type == "train" } ?? []
    }
}

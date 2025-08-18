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
    
    @Published var searchStationText: String = ""
    @Published var filteredStations: [StationModel] = []
    
    var isStationsSelected: Bool {
        selectedFromStation != nil && selectedToStation != nil
    }
    
    private let stationsService: StationsServiceProtocol

    init(stationsService: StationsServiceProtocol = StationsService()) {
        self.stationsService = stationsService
        setupBindings()
    }

    private func setupBindings() {
        $searchStationText
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.filterStations(with: text)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()

    func loadCities() {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        
        Task {
            do {
                let allStationsResponse = try await stationsService.getAllStations()
                guard let countries = allStationsResponse.countries else {
                    await MainActor.run {
                        self.allCities = []
                        self.isLoading = false
                    }
                    return
                }
                
                if let russia = countries.first(where: { $0.title == "Россия" }),
                   let regions = russia.regions {
                    let targetRegions = ["Москва и Московская область", "Санкт-Петербург и Ленинградская область", "Краснодарский край"]
                    let filteredRegions = regions.filter { region in
                        targetRegions.contains(region.title ?? "")
                    }
                    let allSettlements = filteredRegions.flatMap { $0.settlements ?? [] }
                    
                    let validSettlements = allSettlements.filter { city in
                        if let title = city.title {
                            return !title.isEmpty
                        }
                        return false
                    }
                    
                    let filteredCities = validSettlements.filter { settlement in
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
                        self.filterStations(with: self.searchStationText)
                    }
                } else {
                    await MainActor.run {
                        self.allCities = []
                        self.isLoading = false
                    }
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
    
    private func filterStations(with text: String) {
        let allStations = allCities.flatMap { $0.stations ?? [] }
        let filtered = text.isEmpty ? allStations : allStations.filter { station in
            station.title?.lowercased().contains(text.lowercased()) ?? false
        }
        let uniqueStations = Array(filtered.reduce(into: [String: StationModel]()) { dict, station in
            if let yandexCode = station.codes?.yandex_code {
                dict[yandexCode, default: station] = station
            }
        }.values)
        filteredStations = uniqueStations
            .filter { $0.transport_type == "train" }
            .filter { $0.title != nil && !$0.title!.isEmpty }
            .sorted { $0.title! < $1.title! }
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
    
    func isNoStations() -> Bool {
        return self.filteredStations.isEmpty && !self.searchStationText.isEmpty
    }
}

import SwiftUI
import OpenAPIURLSession
import Combine

@MainActor
final class StationsViewModel: ObservableObject {
    
    // MARK: - Published Props
    @Published private(set) var allCities: [CityModel] = []
    @Published private(set) var isLoading: Bool = false
    @Published var error: NetworkError? = nil
    
    @Published var isSelectingFrom: Bool = true
    @Published private(set) var selectedFromStation: StationModel? = nil
    @Published private(set) var selectedToStation: StationModel? = nil
    
    @Published var searchStationText: String = ""
    @Published var filteredStations: [StationModel] = []
    
    @Published var searchCityText: String = ""
    @Published var filteredCities: [CityModel] = []
    @Published var selectedCity: CityModel? = nil
    
    var isStationsSelected: Bool {
        selectedFromStation != nil && selectedToStation != nil
    }
    
    // MARK: - Private Props
    private let stationsService: StationsServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init's
    init(stationsService: StationsServiceProtocol = StationsService()) {
        self.stationsService = stationsService
        setupBindings()
    }
    
    
    // MARK: - Private Methods
    private func setupBindings() {
        // Фильтрация станций
        $searchStationText
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.filterStations(with: text)
            }
            .store(in: &cancellables)
        
        // Фильтрация городов
        $searchCityText
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.filterCities(with: text)
            }
            .store(in: &cancellables)
        
        // Реакция на изменение selectedCity
        $selectedCity
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.filterStations(with: self?.searchStationText ?? "")
            }
            .store(in: &cancellables)
    }
    
    private func filterCities(with text: String) {
        if text.isEmpty {
            filteredCities = allCities
                .sorted { $0.title! < $1.title! } // Полный список при очистке, с сортировкой
        } else {
            let cities = allCities.filter { city in
                city.title?.lowercased().contains(text.lowercased()) ?? false
            }
            filteredCities = cities
                .filter { $0.title != nil && !$0.title!.isEmpty }
                .sorted { $0.title! < $1.title! }
        }
    }
    
    private func filterStations(with text: String) {
        guard let selectedCity = selectedCity, let stations = selectedCity.stations else {
            filteredStations = []
            return
        }
        
        let filtered = text.isEmpty ? stations : stations.filter { station in
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
    
    
    // MARK: - Public Methods
    func loadCities() async {
        guard !isLoading else {
            return
        }

        await MainActor.run {
            isLoading = true
            error = nil
        }

        do {
            let allStationsResponse = try await stationsService.getAllStations()
            guard let countries = allStationsResponse.countries,
                  let russia = countries.first(where: { $0.title == "Россия" }),
                  let regions = russia.regions else {
                await MainActor.run {
                    isLoading = false
                }
                return
            }

            let targetRegions = ["Москва и Московская область", "Санкт-Петербург и Ленинградская область", "Краснодарский край"]
            let filteredRegions = regions.filter { targetRegions.contains($0.title ?? "") }
            let allSettlements = filteredRegions.flatMap { $0.settlements ?? [] }

            let validSettlements = allSettlements.filter { $0.title?.isEmpty == false }
            let filteredCities = validSettlements.filter { settlement in
                guard let stations = settlement.stations else { return false }
                return stations.contains { $0.transport_type == "train" }
            }

            await MainActor.run {
                allCities = filteredCities.map { settlement in
                    var modifiedSettlement = settlement
                    modifiedSettlement.stations = settlement.stations?.filter { $0.transport_type == "train" }
                    return modifiedSettlement
                }
                isLoading = false
            }
        } catch let error as URLError {
            await MainActor.run {
                self.error = error.code == .notConnectedToInternet ? .noInternet : .serverError
                isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = .serverError
                isLoading = false
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
    
    func isNoStations() -> Bool {
        return self.filteredStations.isEmpty && !self.searchStationText.isEmpty
    }
    
    func isNoCities() -> Bool {
        return self.filteredCities.isEmpty && !self.searchCityText.isEmpty
    }
    
    /// Сбрасывает выбор города и станций
    func resetSelection() {
        selectedCity = nil
        filteredStations = []
        searchCityText = ""
        searchStationText = ""
    }
}

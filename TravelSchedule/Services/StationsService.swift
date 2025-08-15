import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Protocol
protocol StationsServiceProtocol {
    func getAllStations() async throws -> AllStationsResponse
//    func getFilteredCities() async throws -> [CityModel] - TODO: Удалить это после переноса во ViewModel
}

// MARK: - Service
final class StationsService: StationsServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getAllStations() async throws -> AllStationsResponse {
       return try await networkClient.getAllStations()
    }
     
//    func getFilteredCities() async throws -> [CityModel] { - TODO: Удалить это после переноса во ViewModel
//        let response = try await getAllStations()
//        guard let countries = response.countries else {
//            return []
//        }
//        
//        if let russia = countries.first(where: { $0.title == "Россия" }),
//           let regions = russia.regions {
//            let targetRegions = ["Москва и Московская область", "Санкт-Петербург и Ленинградская область", "Краснодарский край"]
//            let filteredRegions = regions.filter { region in
//                targetRegions.contains(region.title ?? "")
//            }
//            let allSettlements = filteredRegions.flatMap { $0.settlements ?? [] }
//            
//            let validSettlements = allSettlements.filter { city in
//                if let title = city.title {
//                    return !title.isEmpty
//                }
//                return false
//            }
//            return validSettlements.sorted { $0.title! < $1.title! }
//        }
//        
//        return []
//    }
}

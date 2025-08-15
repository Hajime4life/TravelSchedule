import OpenAPIRuntime
import OpenAPIURLSession
import Foundation


protocol StationsServiceProtocol {
    func getAllStations() async throws -> AllStationsResponse
    func getFilteredCities() async throws -> [CityModel]
}

final class StationsService: StationsServiceProtocol {
    private let apiKey: String
    private let client: Client
    
    init(apiKey: String, client: Client) {
        self.apiKey = apiKey
        self.client = client
    }
    
    func getAllStations() async throws -> AllStationsResponse {
        do {
            let response = try await client.getAllStations(query: .init(apikey: apiKey, transportType: "train"))
            let responseBody = try response.ok.body.html
            let limit = 50 * 1024 * 1024
            let fullData = try await Data(collecting: responseBody, upTo: limit)
            let allStations = try JSONDecoder().decode(AllStationsResponse.self, from: fullData)
            return allStations
        } catch URLError.Code.notConnectedToInternet {
            throw NetworkError.noInternet
        } catch {
            throw NetworkError.serverError
        }
    }
    
    func getFilteredCities() async throws -> [CityModel] {
        let response = try await getAllStations()
        guard let countries = response.countries else {
            return []
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
            return validSettlements.sorted { $0.title! < $1.title! }
        }
        
        return []
    }
}

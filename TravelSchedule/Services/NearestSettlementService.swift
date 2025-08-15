import OpenAPIRuntime
import OpenAPIURLSession

protocol NearestSettlementServiceProtocol {
    func getNearestCity(
        lat: Double,
        lng: Double
    ) async throws -> NearestCityResponse
}

final class NearestSettlementService: NearestSettlementServiceProtocol {

    private let apiKey: String
    private let client: Client
    
    init(apiKey: String, client: Client) {
        self.apiKey = apiKey
        self.client = client
    }
    
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCityResponse {
        let response = try await client.getNearestCity(query: .init(apikey: apiKey, lat: lat, lng: lng))
        return try response.ok.body.json
    }
    
}

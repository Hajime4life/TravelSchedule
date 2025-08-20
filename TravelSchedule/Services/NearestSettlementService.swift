import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Protocol
protocol NearestSettlementServiceProtocol {
    func getNearestCity(
        lat: Double,
        lng: Double
    ) async throws -> NearestCityResponse
}

// MARK: - Service
final class NearestSettlementService: NearestSettlementServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCityResponse {
        return try await networkClient.getNearestCity(lat: lat, lng: lng)
    }
}

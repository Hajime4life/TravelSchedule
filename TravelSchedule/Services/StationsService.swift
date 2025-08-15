import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Protocol
protocol StationsServiceProtocol {
    func getAllStations() async throws -> AllStationsResponse
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
}

import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Protocol
protocol ThreadServiceProtocol {
    func getRouteStations(uid: String) async throws -> ThreadStationsResponse
}

// MARK: - Service
final class ThreadService: ThreadServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getRouteStations(uid: String) async throws -> ThreadStationsResponse {
        return try await networkClient.getRouteStations(uid: uid)
    }
}

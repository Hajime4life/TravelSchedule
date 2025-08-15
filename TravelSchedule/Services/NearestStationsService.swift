import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Protocol
protocol NearestStationsServiceProtocol {
  func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> StationsResponse
}

// MARK: - Service
final class NearestStationsService: NearestStationsServiceProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> StationsResponse {
        return try await networkClient.getNearestStations(lat: lat, lng: lng, distance: distance)
    }
}

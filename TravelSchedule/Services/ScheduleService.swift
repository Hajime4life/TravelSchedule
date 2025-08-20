import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Protocol
protocol ScheduleServiceProtocol {
    func getSchedule(station: String) async throws -> ScheduleResponse
}

// MARK: - Service
final class ScheduleService: ScheduleServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getSchedule(station: String) async throws -> ScheduleResponse {
        return try await networkClient.getSchedule(station: station)
    }
}

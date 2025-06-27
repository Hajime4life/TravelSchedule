import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleResponse = Components.Schemas.ScheduleResponse

protocol ScheduleServiceProtocol {
    func getSchedule(station: String) async throws -> ScheduleResponse
}

final class ScheduleService: ScheduleServiceProtocol {
    private let client: Client
    private let apiKey: String
    
    init(apiKey: String, client: Client) {
        self.client = client
        self.apiKey = apiKey
    }
    
    func getSchedule(station: String) async throws -> ScheduleResponse {
        let response = try await
        client.getStationSchedule(query: .init(apikey: apiKey, station: station))
        return try response.ok.body.json
    }
}


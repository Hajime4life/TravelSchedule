import OpenAPIRuntime
import Foundation
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
        let response = try await client.getStationSchedule(query: .init(apikey: apiKey, station: station))
        print("Hash of response.ok: \(try response.ok.hashValue)")
        
        let decoder = JSONDecoder()
        // Настройка кастомной стратегии декодирования дат
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "HH:mm" // Формат времени из JSON
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Дата \(dateString) не соответствует формату HH:mm")
        }
        
        return try decoder.decode(ScheduleResponse.self, from: try JSONEncoder().encode(response.ok.body.json))
    }
}

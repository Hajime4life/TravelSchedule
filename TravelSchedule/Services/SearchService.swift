import OpenAPIRuntime
import OpenAPIURLSession
import Foundation


protocol SearchServiceProtocol {
    func search(from: String, to: String, transfers: Bool) async throws -> SegmentsResponse
}

final class SearchService: SearchServiceProtocol {
    private let apiKey: String
    private let client: Client
    
    init(apiKey: String, client: Client) {
        self.apiKey = apiKey
        self.client = client
    }
    
    func search(from: String, to: String, transfers: Bool = true) async throws -> SegmentsResponse {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: Date())
        
        do {
            let response = try await client.getSchedualBetweenStations(query: .init(
                apikey: apiKey,
                from: from,
                to: to,
                date: todayString,
                transfers: transfers
            ))
            return try response.ok.body.json
        } catch URLError.Code.notConnectedToInternet {
            throw NetworkError.noInternet
        } catch {
            throw NetworkError.serverError
        }
    }
}

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

typealias Segments = Components.Schemas.Segments

protocol SearchServiceProtocol {
  func search(from: String, to: String, transfers: Bool) async throws -> Segments
}

final class SearchService: SearchServiceProtocol {
  private let apiKey: String
  private let client: Client
  
  init(apiKey: String, client: Client) {
      self.apiKey = apiKey
      self.client = client
  }
  
    func search(from: String, to: String, transfers: Bool = true) async throws -> Segments {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: Date())
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apiKey,
            from: from,
            to: to,
            date: todayString,
            transfers: transfers
            )
        )
        return try response.ok.body.json
  }
}

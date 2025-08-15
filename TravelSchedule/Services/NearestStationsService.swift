import OpenAPIRuntime
import OpenAPIURLSession


protocol NearestStationsServiceProtocol {
  func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> StationsResponse
}

final class NearestStationsService: NearestStationsServiceProtocol {
  private let client: Client
  private let apiKey: String
  
  init(apiKey: String, client: Client) {
    self.apiKey = apiKey
    self.client = client
  }
  
  func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> StationsResponse {
    let response = try await client.getNearestStations(query: .init(
        apikey: apiKey,
        lat: lat,
        lng: lng,
        distance: distance
    ))
    return try response.ok.body.json
  }
}

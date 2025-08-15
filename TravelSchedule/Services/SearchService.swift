import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Protocol
protocol SearchServiceProtocol {
    func search(from: String, to: String, transfers: Bool) async throws -> SegmentsResponse
}

// MARK: - Service
final class SearchService: SearchServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func search(
        from: String,
        to: String,
        transfers: Bool = true
    ) async throws -> SegmentsResponse {
        return try await networkClient.search(from: from, to: to, transfers: transfers)
    }
}

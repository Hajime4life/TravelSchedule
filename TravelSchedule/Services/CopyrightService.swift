import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Protocol
protocol CopyrightServiceProtocol {
    func getCopyrightInfo() async throws -> CopyrightResponse
}

// MARK: - Service
final class CopyrightService: CopyrightServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func getCopyrightInfo() async throws -> CopyrightResponse {
        return try await networkClient.getCopyrightInfo()
    }
}

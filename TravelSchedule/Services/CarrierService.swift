import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Protocol
protocol CarrierServiceProtocol {
    func getCarrierInfo(code: String) async throws -> CarrierResponse
}

// MARK: - Service
final class CarrierService: CarrierServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getCarrierInfo(code: String) async throws -> CarrierResponse {
        try await networkClient.getCarrierInfo(code: code)
    }
}

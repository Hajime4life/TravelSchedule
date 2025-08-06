import SwiftUI
import OpenAPIURLSession
import Combine

class CarrierListViewModel: ObservableObject {
    @Published var segments: [Components.Schemas.Segment] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let searchService: SearchService
    private let stationsViewModel: StationsViewModel
    
    init(apiKey: String, stationsViewModel: StationsViewModel) {
        self.searchService = SearchService(
            apiKey: apiKey,
            client: Client(
                serverURL: try! Servers.Server1.url(),
                transport: URLSessionTransport()
            )
        )
        self.stationsViewModel = stationsViewModel
    }
    
    func loadSegments() {
        guard !isLoading else { return }
        guard let fromStation = stationsViewModel.selectedFromStation,
              let toStation = stationsViewModel.selectedToStation,
              let fromCode = fromStation.codes?.yandex_code,
              let toCode = toStation.codes?.yandex_code else {
            errorMessage = "Не выбраны станции отправления или прибытия"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await searchService.search(
                    from: fromCode,
                    to: toCode//,
                    //transport_types: ["train"] // Explicitly filter for train segments
                )
                let filteredSegments = response.segments?.filter { segment in
                    segment.thread?.transport_type == "train"
                } ?? []
                
                await MainActor.run {
                    self.segments = filteredSegments
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Ошибка загрузки рейсов: \(error.localizedDescription)"
                    self.segments = []
                    self.isLoading = false
                }
            }
        }
    }
}

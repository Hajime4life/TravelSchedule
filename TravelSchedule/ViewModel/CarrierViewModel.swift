import SwiftUI
import OpenAPIURLSession
import Combine

class CarrierViewModel: ObservableObject {
    
    @Published var segments: [Components.Schemas.Segment] = []
    
    private let searchService: SearchService
    
    init() {
        self.searchService = SearchService(
            apiKey: apiKey,
            client: Client(
                serverURL: try! Servers.Server1.url(),
                transport: URLSessionTransport()
            )
        )
    }
    
    func loadRaces(stationsViewModel: StationsViewModel) {
        if let fromStation = stationsViewModel.selectedFromStation,
           let toStation = stationsViewModel.selectedToStation {
            Task {
                do {
                    let response = try await searchService.search(
                        from: "s9613091", // fromStation.codes?.yandex_code ?? "",
                        to: "s2000003" // toStation.codes?.yandex_code ?? ""
                    )
                    segments = response.segments ?? []
                } catch {
                    print("Ошибка загрузки рейсов: \(error.localizedDescription)")
                    segments = []
                }
            }
        }
    }
    
    // Форматирование даты отправления
    func formatDepartureDate(startDate: String?) -> String {
        guard let startDate = startDate else {
            return "N/A"
        }
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: startDate) else {
            return "N/A"
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM"
        outputFormatter.locale = Locale(identifier: "ru_RU")
        return outputFormatter.string(from: date)
    }
    
    // Форматирование времени отправления
    func formatDepartureTime(departure: String?) -> String {
        guard let departure = departure else {
            return "N/A"
        }
        // Input is in HH:mm:ss, extract HH:mm
        let components = departure.split(separator: ":")
        guard components.count >= 2 else {
            return "N/A"
        }
        return "\(components[0]):\(components[1])"
    }
    
    // Форматирование времени прибытия
    func formatArrivalTime(arrival: String?) -> String {
        guard let arrival = arrival else {
            return "N/A"
        }
        // Input is in HH:mm:ss, extract HH:mm
        let components = arrival.split(separator: ":")
        guard components.count >= 2 else {
            return "N/A"
        }
        return "\(components[0]):\(components[1])"
    }
    
    // Форматирование длительности
    func formatDuration(duration: Int?) -> String {
        guard let duration = duration else {
            return "N/A"
        }
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        if hours == 0 {
            return "\(minutes) мин"
        }
        if minutes == 0 {
            return "\(hours) часов"
        }
        return "\(hours) ч \(minutes) мин"
    }
    
    // Форматирование даты прибытия
    func formatArrivalDate(startDate: String?, departure: String?, duration: Int?) -> String {
        guard let startDate = startDate, let departure = departure, let duration = duration else {
            return "N/A"
        }
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let fullDateString = "\(startDate) \(departure)"
        guard let departureDate = inputFormatter.date(from: fullDateString) else {
            return "N/A"
        }
        
        let arrivalDate = departureDate.addingTimeInterval(TimeInterval(duration))
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM"
        outputFormatter.locale = Locale(identifier: "ru_RU")
        return outputFormatter.string(from: arrivalDate)
    }
}
